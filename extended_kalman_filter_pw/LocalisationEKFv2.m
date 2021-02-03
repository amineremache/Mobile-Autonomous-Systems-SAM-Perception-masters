%****************************************************************************************
% LocalisationEKF
% Module de localisation non linéaire par approche EKF
%
% Fichier          : $RCSfile: LocalisationEKF.m,v $
% Auteur           : Dominique Gruyer 							
%	    
%****************************************************************************************/

clear all; close all; home; clc ;format long;

DonneesLocalisationEKF  =   struct('X_E',[],'P_E',[],'Temps',0,'CapteurUtilise',0);

PasCodeur = 0.1954;

disp(' Lancement de l''algorithme de localisation EKF et IMM avec les données :');
disp('   --> Topo');
disp('   --> Inertielles VG400');
disp('   --> Gyro KVH');
disp('   --> Compass KVH');
disp('   --> Angle au Volant');
disp('   --> GPS A12 ou DGPS AG132');
disp('   --> GPS RTK Sagitta pour la référence');

%==========================================================================
% Initialisation des bruits du systeme et des capteurs
% Dans cette structure le bruit GPS n'est pas pris en compte car il est
% calculé à partir des données renvoyées par le capteur dans les trames
% NMEA
%==========================================================================
% Ecart type des données
SigmaCodeur     = 0.01;                    % ecart type de 1cm pour codeur roue
SigmaGyro       = 0.0015;                  % PENSEZ A LE MULT PAR DeltaTemps lors de l'utilisation  % ecart type de 0.0015 rad/s pour gyromètre qu'on multiplie par Delta Temps
SigmaPsi        = ((1^0.5 *3.14/180));     % ecart type de 1 degré pour angle au volant 
SigmaModelX     = 0.01;                    % bruit du model : 1cm en x
SigmaModelY     = 0.01;                    % bruit du model : 1cm en y
SigmaModelTheta = 0.0015;                  % 

BruitsSystemeCapteurs = struct( 'SigmaCodeur',      SigmaCodeur,...
                                'SigmaGyro',        SigmaGyro,...
                                'SigmaPsi',         SigmaPsi,...
                                'SigmaModelX',      SigmaModelX,...
                                'SigmaModelY',      SigmaModelY,...
                                'SigmaModelTheta',  SigmaModelTheta);
           

%==========================================================================
%        CHARGEMENT DES DONNEES DES PISTES (Routière et Val d'Or)
%==========================================================================
% Chargement des coordonnées des pistes de la routière et du val d'or
disp(' Chargement des données des pistes !!!!');
% La référence est le lieu de l'antenne du GPS RTK Thalès permanente de
% SATORY. Cette position correspond à:
% longitude: 2° 5' 32.15779          latitude: 48° 47' 11.07122       altitude: 216.937 m
[XRef,YRef] = ConverterLL2XY(((48+47/60+11.07122/3600)*pi)/180,((2+5/60+32.15779/3600)*pi)/180);
ZRef = 216.937;
ReferenceGPS = [XRef YRef ZRef];
fprintf(' Le Point de référence est XRef: %6.3f  YRef: %6.3f ZRef: %6.3f\n', XRef ,YRef ,ZRef );

[PisteRoutiere,PisteValdOr] = ChargementPistesReferences( ReferenceGPS , 1);

fprintf('\n\nChargements des fichiers des pistes terminés\n\n');

%==========================================================================
%           CHARGEMENT DES DONNEES CAPTEURS
% Tous les angles sont en rad et les vitesses angulaires en rad/s
% Les positions sont en mètres
% Les vitesses en m/s 
% Les acceleration en m/s^2 
%==========================================================================
disp(' Chargement des données FUDOLO (Fusion de Données pour la Localisation)!!!!');
%   Data = struct('gps',[],'angleroue',[],'ins',[],'gyro',[],'topo',[],'compass',[]);
%   gps         =   struct('type','AG132','x',[],'y',[],'z',[],'HDOP',[],'mode',[],'timeUTC',[],'timeRTMaps',[],'retard',0.0,'valide',[],'a',[],'b',[],'phi',[]);
%   angleroue   =   struct('angle',[],'timeUTC',[],'timeRTMaps',[]);
%   ins         =   struct('gyroscope',[], 'gyrometre',[],'acc',[],'timeUTC',[],'timeRTMaps',[]); 
%   gyro        =   struct('gyrometre',[],'timeUTC',[],'timeRTMaps',[]);
%   topo        =   struct('topo',[],'vitesse',[],'timeUTC',[],'timeRTMaps',[]);
%   compass     =   struct('compass',[],'timeUTC',[],'timeRTMaps',[]);
%========================================================================
DonneeSyncho = 1;
if DonneeSyncho
    Data = ChargementDonneesFUDOLOSyncho5Hz([],PisteValdOr,PisteRoutiere);
else
    Data = ChargementDonneesFUDOLO([],PisteValdOr,PisteRoutiere);
end;

fprintf('\n\nChargements et corrections des fichiers d''acquisitions terminés\n\n');

%================================================================
% 							PHASE D'INITIALISATION
%================================================================
% Indices temporels pour les capteurs suivants:
% 		Indices=[Topo INS Gyro compass GPS RTK]
% Afin de synchroniser les différents indices, nous cherchons
% dans la première ligne des données des capteurs le temps le 
% plus tard. 
%===============================================================
Indices = ones(1,7);
IndicesActifs = [1 0 0 0 0 0 0]; % On active uniquement les boucles avec le topometre et le GPS

OffSet = 5;
[Valeur, IndiceTempsUTCReference] = max([   Data.topo.timeUTC(OffSet) ...
                                            Data.ins.timeUTC(OffSet) ...
                                            Data.gyro.timeUTC(OffSet) ...
                                            Data.compass.timeUTC(OffSet) ...
                                            Data.angleroue.timeUTC(OffSet) ...
                                            Data.gps.timeUTC(OffSet)]);
TempsCourant = Valeur;
                                  
for IndiceCapteur = 1:length(Indices)
    switch ( IndiceCapteur )
        case 1,
            Indice = find(Data.topo.timeUTC<=Valeur);
            Indices(1,1) = Indice(length(Indice));
        case 2,
            Indice = find(Data.ins.timeUTC<=Valeur);
            Indices(1,2) = Indice(length(Indice));
        case 3,
            Indice = find(Data.gyro.timeUTC<=Valeur);
            Indices(1,3) = Indice(length(Indice));
        case 4,
            Indice = find(Data.compass.timeUTC<=Valeur);
            Indices(1,4) = Indice(length(Indice));
        case 5,
            Indice = find(Data.angleroue.timeUTC<=Valeur);
            Indices(1,5) = Indice(length(Indice));
        case 6,
            Indice = find(Data.gps.timeUTC<=Valeur);
            Indices(1,6) = Indice(length(Indice));
        case 7,
            Indice = find(Data.rtk.timeUTC<=Valeur);
            Indices(1,7) = Indice(length(Indice));
        otherwise, disp([' Capteur non pris en compte !!!']);
    end;
end;

%===========================================================================================================
% INITIALISATION DU FILTRE:
% EKF: Kalman filter
% La structure du code proposée permet de pouvoir ajouter d'autres filtres (UKF, Particle filter, IMM, ...)
%===========================================================================================================
InitialisationFiltres;

Localisation=figure( ...
    'Name','LOCALISATION DYNAMIQUE EKF', ...
    'NumberTitle','on', ...
    'Resize','on',...
    'DoubleBuffer','on', ...
    'Visible','on', ...
    'position',[10 10 500 500 ],...
    'BackingStore','on','pointer','arrow');
axes( ...
    'Units','normalized', ...
    'Position',[0.05 0.15 0.85 0.8], ...
    'Visible','on', ...
    'DrawMode','fast', ...
    'NextPlot','add');
Alpha = .5;

set(Localisation, 'Renderer','OpenGL');
axis tight;
camlight; 

%================================================================================================
%											BOUCLE PRINCIPALE
%================================================================================================
%   Data = struct('gps',[],'angleroue',[],'ins',[],'gyro',[],'topo',[],'compass',[]);
%   gps         =   struct('x',[],'y',[],'z',[],'HDOP',[],'mode',[],'timeUTC',[],'timeRTMaps',[]);
%   angleroue   =   struct('angle',[],'timeUTC',[],'timeRTMaps',[]);
%   ins         =   struct('gyroscope',[], 'gyrometre',[],'acc',[],'timeUTC',[],'timeRTMaps',[]); 
%   gyro        =   struct('gyrometre',[],'timeUTC',[],'timeRTMaps',[]);
%   topo        =   struct('topo',[],'vitesse',[],'timeUTC',[],'timeRTMaps',[]);
%   compass     =   struct('compass',[],'timeUTC',[],'timeRTMaps',[]);
%================================================================
%   Indices=[Topo INS Gyro compass GPS RTK AngleVolant]
%================================================================
 
%-----------------------------------------------------------------------------------------------------------------  
    disp(' INITIALISATION FAITE !!! APPUYER SUR UNE TOUCHE !!!');
    disp([' Indice courant Topo: ',     num2str(Indices(1,1)),' Indice max Topo: ',     num2str(length(Data.topo.timeUTC))]);
    disp([' Indice courant INS: ',      num2str(Indices(1,2)),' Indice max INS: ',      num2str(length(Data.ins.timeUTC))]);
    disp([' Indice courant Gyro: ',     num2str(Indices(1,3)),' Indice max Gyro: ',     num2str(length(Data.gyro.timeUTC))]);
    disp([' Indice courant Compass: ',  num2str(Indices(1,4)),' Indice max Compass: ',  num2str(length(Data.compass.timeUTC))]);
    disp([' Indice courant AngleRoue: ',num2str(Indices(1,5)),' Indice max AngleRoue: ',num2str(length(Data.angleroue.timeUTC))]);    
    disp([' Indice courant GPS: ',      num2str(Indices(1,6)),' Indice max GPS: ',      num2str(length(Data.gps.timeUTC))]);
    disp([' Indice courant RTK: ',      num2str(Indices(1,7)),' Indice max RTK: ',      num2str(length(Data.rtk.timeUTC))]);
%-----------------------------------------------------------------------------------------------------------------  

  
  disp('APPUYER SUR UNE TOUCHE AFIN DE COMMENCER LA BOUCLE PRINCIPALE D EXECUTION DE LA LOCALISATION EKF');
  pause;
  
  %************************************************************************
  %                         BOUCLE PRINCIPALE
  %************************************************************************
  
  while (   (Indices(1,1)<length(Data.topo.timeUTC)) & ...
            (Indices(1,2)<length(Data.ins.timeUTC)) & ...
            (Indices(1,3)<length(Data.gyro.timeUTC)) & ...
            (Indices(1,5)<length(Data.angleroue.timeUTC)) & ...
            (Indices(1,6)<length(Data.gps.timeUTC)) & ...
            (Indices(1,7)<length(Data.rtk.timeUTC)) & ...
            (NbEtape < 1950 ))
    
  % figure(Localisation);
   hold on;
    
    % GESTION TEMPORELLE DES DONNEES
    %==================================
    [TempsCourant, IndiceCourant] = min([   Data.topo.timeUTC(Indices(1)) ...
                                            Data.ins.timeUTC(Indices(2)) ...
                                            Data.gyro.timeUTC(Indices(3)) ...
                                            Data.compass.timeUTC(Indices(4)) ...
                                            Data.angleroue.timeUTC(Indices(5)) ...
                                            Data.gps.timeUTC(Indices(6)) ...
                                            Data.rtk.timeUTC(Indices(7))]);
                                        
  switch (IndiceCourant)
        
        case 1,
        % Traitement des données proprioceptives    
        if (IndicesActifs(1,1))
            
            % 1 tick est estimé à 19.54cm
            if DonneeSyncho
                Dist_topo_2 =  Data.topo.topo(Indices(1,IndiceCourant));
                Dist_topo_1 =  Data.topo.topo(Indices(1,IndiceCourant)-1);
            else
                Dist_topo_2 =   Data.topo.topo(Indices(1,IndiceCourant))*PasCodeur;        % Distance = nbTic * 19.54cm
                Dist_topo_1 =   Data.topo.topo(Indices(1,IndiceCourant)-1)*PasCodeur;      % Distance = nbTic * 19.54cm
            end;
            Var_S       =   Dist_topo_2 - Dist_topo_1;
            Temps_2     =   Data.topo.timeUTC(Indices(1,IndiceCourant))/1000000;        % conversion micoseconde en seconde
            Temps_1     =   Data.topo.timeUTC(Indices(1,IndiceCourant)-1)/1000000;      % conversion micoseconde en seconde
            DeltaTemps  =   (Temps_2 - Temps_1);
            Vit_Topo    =   Var_S / DeltaTemps;                                         % en m/sec
            AngleRoue   =   Data.angleroue.angle(Indices(1,5),1);                       % radian 

        if CapteurUtilise==1
                % Faire attention, entre la VG400 et la KVH, les données sont
                % inversées. Pour ces 2 capteurs, les données sont en degré/s
                Vit_Lacet   =   -Data.ins.gyrometre(Indices(1,2),3);        % données de la VG400 en rad/s
                %Vit_Lacet2  =   Data.gyro.gyrometre(Indices(1,3),1);       % données de la KVH en rad/s  
                Var_Theta   =   Vit_Lacet * DeltaTemps;                     % en seconde
        else

            Temps_1     =   VehiculeNL.TempsCourant;                    % en seconde
            DeltaTemps  =   (Temps_2 - Temps_1);
            Var_S       =   Vit_Topo * DeltaTemps;                      % en seconde
            Vit_Lacet   =   -Data.ins.gyrometre(Indices(1,2),3);        % données de la VG400 en rad/s
            Var_Theta   =   Vit_Lacet * DeltaTemps;
       end;  
       
            % Récupération des matrices pour l'étape de prédiction.
            [Fk,Hk,Bk,Q_systeme]  =     ModeleEvolutionNL(Var_S,Var_Theta,VehiculeNL.X_E(3),VarSysteme,AngleRoue);

            [X_P,P_P]               =   PredictionKalmanNL(Var_S,Var_Theta,Fk,VehiculeNL.X_E,VehiculeNL.P_E,Q_systeme,AngleRoue);
            VehiculeNL.X_E = X_P;
            VehiculeNL.P_E = P_P;
            VehiculeNL.TempsCourant = Temps_2; 
                           
           CapteurUtilise=1;
           
        end; 
        
%==========================================================================

      case 2,
            
        if (IndicesActifs(1,2))
            CapteurUtilise  =   2;
        end;
        
%==========================================================================
        case 3,
            
        if (IndicesActifs(1,3))
            CapteurUtilise  =   3;
        end;
        
%==========================================================================
        case 4,

        if (IndicesActifs(1,4))                      
          CapteurUtilise    =   4;
        end;
        
%=========================================================================================
        case 5,
            
        if (IndicesActifs(1,5))                      
              CapteurUtilise =   5;
        end;
                    
%==========================================================================================
        case 6,
        %  Traitement des données GPS     
        if (IndicesActifs(1,6))
                %==========================================================================
                % 				DONNEES GPS
                %==========================================================================
                X_gps =   Data.gps.x(Indices(1,IndiceCourant));
                Y_gps =   Data.gps.y(Indices(1,IndiceCourant));
                
                % On recherche la distance parcourue et la variation de cap appliquées
                % au véhicule entre la dernière prédiction et l'instant courant.
                %  
                % Ceci afin de construire la prédiction recalée avec l'observation
                %==========================================================================
                %   CALCUL DE LA DISTANCE PARCOURUE
                if DonneeSyncho
                    Dist_topo_2 =  Data.topo.topo(Indices(1,1));
                    Dist_topo_1 =  Data.topo.topo(Indices(1,1)-1);
                else
                    Dist_topo_2 =   Data.topo.topo(Indices(1,1))*PasCodeur;           % Distance = nbTic * 19.54cm
                    Dist_topo_1 =   Data.topo.topo(Indices(1,1)-1)*PasCodeur;         % Distance = nbTic * 19.54cm
                end;
                % Calcul de la vitesse à partir des dernières données du topometre
                Var_S       =   Dist_topo_2 - Dist_topo_1;
                Temps_2     =   Data.topo.timeUTC(Indices(1,1))/1000000;              % conversion micoseconde en seconde
                Temps_1     =   Data.topo.timeUTC(Indices(1,1)-1)/1000000;            % conversion micoseconde en seconde
                DeltaTemps  =   (Temps_2 - Temps_1);
                Vit_Topo    =   Var_S / DeltaTemps;                                   % estimation de la vitesse du véhicule en m/s
                % adaptation de cette vitesse à l'intervalle de temps entre
                % la donnée GPS courante et la date de la derniere mesure
                Temps_2     =   Data.gps.timeUTC(Indices(1,IndiceCourant))/1000000;   % temps courant du GPS en seconde
                Temps_1     =   VehiculeNL.TempsCourant;                              % temps de la dernière prédiction en seconde
                DeltaTemps  =   (Temps_2 - Temps_1);                                  % Différence de temps entre le temps courant GPS et le temps de la dernière prédiction
                Var_S       =    Vit_Topo * DeltaTemps;                               % distance en m parcouru depuis la dernière prédiction
                %   CALCUL DE LA VARIATION DE CAP
                Vit_Lacet   =   -Data.ins.gyrometre(Indices(1,2),3);                  % données de la VG400 en rad/s
                Var_Theta   =   Vit_Lacet * DeltaTemps;                               % données de variation d'angle de la VG400 en rad
                AngleRoue   =   Data.angleroue.angle(Indices(1,5));
                % Si le dernier capteur utilisé était le GPS alors on prend
                % le temps dans la structure X_E_IMM sinon dans X_P_IMM
               
                %==========================================================
                % Etat du GPS: est ce qu'il est valide, quel est son mode de
                % fonctionnement, quelles sont ces variances (axes X et Y), 
                % quelle est sa rotation.
                % Mode GPS, 1 gps naturel, 2 différentiel EGNOS, 0 masquage
                %=========================================================
                if (strcmp(Data.gps.type,'AG132'))
                    if isempty( Data.gps.valide )
                        ModeGPS     = Data.gps.mode(Indices(1,IndiceCourant));
                        Valide      = 1;
                        SigmaA      = 0;
                        SigmaB      = 0;
                        Phi         = 0;
                    else
                        Valide      = Data.gps.valide(Indices(1,IndiceCourant));
                        ModeGPS     = Data.gps.mode(Indices(1,IndiceCourant));    
                        SigmaA      = Data.gps.a(Indices(1,IndiceCourant));
                        SigmaB      = Data.gps.b(Indices(1,IndiceCourant));
                        Phi         = Data.gps.phi(Indices(1,IndiceCourant));
                    end;
                else
                    ModeGPS         = 1;
                    Valide          = 1;
                    SigmaA          = 0;
                    SigmaB          = 0;
                    Phi             = 0;
                end;
                               
                % Recalage spatial et temporel de l'EKF sur les données de mise à jour de l'estimation
                [Fk,Hk,Bk,Q_systeme,Q_GPS]  =   ModeleEvolutionGPSNL(Var_S,Var_Theta,VehiculeNL.X_E(3),VarSysteme,ModeGPS,Valide,SigmaA,SigmaB,Phi,AngleRoue);

                [X_P,P_P]                   =   PredictionKalmanNL(Var_S,Var_Theta,Fk,VehiculeNL.X_E,VehiculeNL.P_E,Q_systeme,AngleRoue);
                
                %===========================================================
                % ETAPE D'ESTIMATION : instant k/k
                % calcul de :
                %					         -1
                % Kk = P(k/k-1) H(k)'(H(k) P(k/k-1)H(k)' + R(k))
                % X_E(k/k) = X_E(k/k-1) + Kk(Y(k) - Y_E(k/k-1))
                % P(k/k) = P(k/k-1) - KkH(k)P(k/k-1) = (I - KkH(k))P(k/k-1)
                %===========================================================
                [X_E,P_E,Sk]   =   EstimationKalmanNL(P_P,Hk,X_P,[X_gps; Y_gps],Q_GPS);
                
                % mise à jour de la structure VehiculeNL
                %=============================================
                VehiculeNL.X_E              =   X_E;
                VehiculeNL.P_E              =   P_E;     
                VehiculeNL.TempsCourant     =   Temps_2;
                
                NbEtape = NbEtape + 1;
                
                CapteurUtilise =   6;
                
       end; % end if (IndicesActifs(1,6))
            
 %==========================================================================
 
        case 7,

        if (IndicesActifs(1,7))                      
            CapteurUtilise =   7;
        end;
        
      otherwise,   
            disp('Error dans le switch');
            
    end; % end switch (IndiceCourant)
    
    % on ramene l'angle du vehicule (cap) entre 0 et 2*pi
    if (VehiculeNL.X_E(3) > 2*pi)
        VehiculeNL.X_E(3) = VehiculeNL.X_E(3)-2*pi;
    end

  % Passage à l'indice suivant pour le capteur que nous venons de traiter  
  Indices(1,IndiceCourant)    =   Indices(1,IndiceCourant)+1;
 
    
%============================================================================
% 	AFFICHAGE DE LA POSITION ESTIMEE DU VEHICULE POUR CHAQUE FILTRE
%============================================================================   
 DisplayStateVectorResults;
    
    
%======================================================================
% MISE A JOUR DES STRUCTURES DE SAUVEGARDES DES RESULTATS DES FILTRES 
%======================================================================
UpdateRecordStructures;  
    
end; % end de while ((Indices(1,1)<length(Data.topo.timeUTC))...


disp(' Fin du programme de localisation ......................');


%==================================================================
% Sauvegarde des résultats obtenus par le filtre de Kalman
%==================================================================
save ResultatFiltres/Sans_ResultatGPSINSTopoEKF3 DonneesLocalisationEKF;