%****************************************************************************************
% ChargementDonneesFUDOLOSyncho5Hz
% Module de chargement des données des capteurs FUDOLO
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: ChargementDonneesFUDOLO.m,v $
% Date de creation : 2007/26/05
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/26/05 14:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données des capteurs synchronisés à 5Hz:
%                           topometre, 
%                           INS VG400,
%                           Compass KVH,
%                           Gyrometre KVH,
%                           GPS AG132 
%****************************************************************************************/
function [DataSynch] = ChargementDonneesFUDOLOSyncho5Hz(DataSynch,PisteValdOr,PisteRoutiere);

format long;

Data = struct('gps',[],'angleroue',[],'ins',[],'gyro',[],'topo',[],'compass',[],'vision',[],'rtk',[]);
Affichage = 1;

load SensorsData/DonneesFUDOLOSynchrones.mat;

%========================================================================
% Dans cette structure recalée, toutes les données sont rammenées
% à 5 Hz. Dans cette structure Data, on a les sous structures suivantes:
%   pps
%   ag132
%   vg400
%   volant
%   odometre
%=========================================================================

%===========================================
% Chargement des données GPS: AG132
% La sortie de cette fonction fournie une matrice avec:
% Colonne1: Temps (UTC)
% Colonne2: Temps (RTMaps)
% Colonne3: Coordonnées en X (metre)
% Colonne4: Coordonnées en Y (metre)
% Colonne5: Coordonnées en Z (metre)
% Colonne6: HDOP
% Colonne7: Mode GPS, 1 gps naturel, 2 différentiel EGNOS, 0 masquage 
% Colonne8: Retard entre la reception du recepteur et la mise à disposition
% (en seconde)
%===========================================
% Afin de déterminer la variance, il faut utiliser le fichier GST
disp(' Entrée chargement GPS AG132 ');

GPS_AG132 = [];
% Chargement du temps (Temps UTC en microsecondes)
GPS_AG132 = [GPS_AG132 data.pps.t(:,1)];
% Chargement du temps (Temps RTMaps en microsecondes)
GPS_AG132 = [GPS_AG132 data.pps.t(:,1)];
% Chargement des coordonnées cartésiens
% G2C_RGF   transforme les coordonnees geographiques en cartesiennes pour le RGF
%	        ces coordonnees peuvent etre scalaires ou vectorielles
%	        entrées: longitude,latitude,h en rad et m
%	        sorties: X,Y,Z en m
VecteurX = [];
VecteurY = [];
ReferencePiste = 0;
for i=1:size(data.ag132.lat,1)
    [X,Y] = ConverterLL2XY(data.ag132.lat(i,1),data.ag132.lon(i,1));
    VecteurX = [VecteurX; X];
    VecteurY = [VecteurY; Y];
end;
VecteurX = VecteurX - PisteRoutiere.ref(1,1);
VecteurY = VecteurY - PisteRoutiere.ref(1,2);
VecteurZ = data.ag132.h(:,1) - PisteRoutiere.ref(1,3);
GPS_AG132 = [GPS_AG132 VecteurX VecteurY VecteurZ];

% HDOP: Dilution Of Precision pour la composante planisférique
% HDOP = sqrt(Rho_est^2 + Rho_nord^2)/Rho_mesure
GPS_AG132 = [GPS_AG132 data.ag132.hdop(:,1)];

% Coordonnées du mode
GPS_AG132 = [GPS_AG132 data.ag132.mode(:,1)];
disp(' Création de la matrice de données _GPS_AG132 fait !!');

% Chargement du retard entre la reception du signal et la mise à
% disposition (en seconde)
%Retard = AG132_GGA(:,4) - floor(AG132_GGA(:,4));
Retard = zeros(length(data.ag132.lon),1);
GPS_AG132 = [GPS_AG132 Retard];
clear Retard;

% chargement de la validité d'une mesure
GPS_AG132 = [GPS_AG132 data.ag132.valid(:,1)];

% chargement des sigmas pour les 2 axes et de la rotation
GPS_AG132 = [GPS_AG132 data.ag132.a(:,1)];
GPS_AG132 = [GPS_AG132 data.ag132.b(:,1)];
GPS_AG132 = [GPS_AG132 data.ag132.phi(:,1)];

disp(' Sortie chargement GPS AG132 ');

%===========================================
% Chargement des données GPS RTK: Sagitta
% La sortie de cette fonction fournie une matrice avec:
% Colonne1: Temps (UTC)
% Colonne2: Temps (RTMaps)
% Colonne3: Coordonnées en X (metre)
% Colonne4: Coordonnées en Y (metre)
% Colonne5: Coordonnées en Z (metre)
% Colonne6: HDOP
% Colonne7: Mode GPS -> nombre de satellites visibles
% Colonne8: Retard entre la reception du recepteur et la mise à disposition
% (en seconde)
%===========================================
disp(' Entrée chargement GPS RTK Sagitta ');
[GPS_Sagitta ] = ChargementGPS_Sagitta([],PisteRoutiere.ref);
disp(' Sortie chargement GPS RTK Sagitta ');

%============================================
%   CHARGEMENT DONNEES PROPRIOCEPTIVE
%============================================
%===========================================
% Chargement des données de braquage de la roue avant
% Time (UTC) |Time (RTMaps) |Time (RTMaps) | Braquage des roues en radians. 
% La valeur de braquage est négatif lorsque le véhicule tourne à gauche, 
% positif lorsque le véhicule tourne à droite.
% La sortie de cette fonction donne:
% Time (UTC) | Time (RTMaps) | Braquage des roues en radians.
% La conversion est réalisée en utilisant les données de temps du fichier AG132_GGA
%===========================================
disp(' Entrée chargement Braquage roue ');

Braquage_Rad = [];
% Chargement du temps (Temps UTC en microsecondes)
Braquage_Rad = [Braquage_Rad data.pps.t(:,1)];
% Chargement du temps (Temps RTMaps en microsecondes)
Braquage_Rad = [Braquage_Rad data.pps.t(:,1)];
Braquage_Rad = [Braquage_Rad data.volant.braq(:,1)];

disp(' Sortie chargement Braquage roue ');

%==========================================================
% Chargement des données de la centrale inertielle : VG400
% log_com3.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : 
% Data From CrossBow DMU-HDX INS equivalent to VG400-CC-100
% Time (UTC)| Angle Pitch/Roll (deg) | AngleRate X,Y,Z (rad/s) | Accel X,Y,Z (m/s²) | Temp (°C)
% La sortie de cette fonction donne:
% Time (UTC)| Time (RTMaps)| Angle Pitch/Roll (deg) | AngleRate X,Y,Z (rad/s) | Accel X,Y,Z (m/s²) | Temp (°C)
% La conversion est réalisée en utilisant les données de temps du fichier AG132_GGA
%==========================================================
disp(' Entrée chargement INS VG400 ');

INS_VG400 = [];
% Chargement du temps (Temps UTC en microsecondes)
INS_VG400 = [INS_VG400 data.pps.t(:,1)];
% Chargement du temps (Temps RTMaps en microsecondes)
INS_VG400 = [INS_VG400 data.pps.t(:,1)];
VectorNull = zeros(size(data.pps.t(:,1),1),1);
INS_VG400 = [INS_VG400 VectorNull]; % nous n'avons pas ces données d'angle
INS_VG400 = [INS_VG400 VectorNull]; % nous n'avons pas ces données d'angle
INS_VG400 = [INS_VG400 data.vg400.omegax(:,1)]; % données de vitesse de rotation en rad/s ramenée en degré/s
INS_VG400 = [INS_VG400 data.vg400.omegay(:,1)]; % données de vitesse de rotation en rad/s ramenée en degré/s
INS_VG400 = [INS_VG400 data.vg400.omegaz(:,1)]; % données de vitesse de rotation en rad/s ramenée en degré/s
INS_VG400 = [INS_VG400 data.vg400.accelx(:,1)]; % données d'acceleration en m/s²
INS_VG400 = [INS_VG400 data.vg400.accely(:,1)]; % données d'acceleration en m/s²
INS_VG400 = [INS_VG400 data.vg400.accelz(:,1)]; % données d'acceleration en m/s²
INS_VG400 = [INS_VG400 VectorNull]; % nous n'avons pas ces données de tempétature
phip      = diff([data.vg400.omegax(:,1);data.vg400.omegax(1,1)])/0.2;
INS_VG400 = [INS_VG400 phip]; % données de la dérivée de la vitesse de rotation
% Phip = diff([Data.ins.gyrometre(:,1);Data.ins.gyrometre(1,1)])/0.2; % vitesse de roulis

disp(' Sortie chargement INS VG400 ');

%==========================================================
% Chargement des données odometrique
% log_com6.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data from Vehicle Odometer
% Time of Tick Rising Edge | Number of ticks (modulo 65536) - 1 tick estimated to 19.54cm -
% Le sortie de cette fonction donne:
% Time (UTC) | Time (RTMaps) | Number of ticks 
%==========================================================
disp(' Entrée chargement Odometre ');
Odometre = [];
% Chargement du temps (Temps UTC en microsecondes)
Odometre = [Odometre data.pps.t(:,1)];
% Chargement du temps (Temps RTMaps en microsecondes)
Odometre = [Odometre data.pps.t(:,1)];
% Chargement de la distance parcourue
% La distance fournie dans data.odometre est Var_S
% afin de pouvoir l'utiliser correctement, nous allons 
% reconstituer une distance parcourue croissante
Odo = [data.odometre.dist(1,1)];
for i=2:length(data.odometre.dist)
    Odo = [Odo ;  (Odo(i-1,1) + data.odometre.dist(i,1))];
end;
Odometre = [Odometre Odo(:,1)];
clear Odo;

disp(' Sortie chargement Odometre ');

%==========================================================================
% CONSTRUCTION DE LA STRUCTURE DE DONNEES IMM
% Dans cette structure nous allons retrouver toutes les données 
% proprioceptive et extéroceptive necessaire à la construction 
% d'un localisation
%=========================================================================
AG132 = 1;

%   Affectation des champs de la structure de sortie
%==========================================================================
gps         =   struct('type','AG132','x',[],'y',[],'z',[],'HDOP',[],'mode',[],'timeUTC',[],'timeRTMaps',[],'retard',0.0,'valide',[],'a',[],'b',[],'phi',[]);
angleroue   =   struct('type','Braquage','angle',[],'timeUTC',[],'timeRTMaps',[]);
ins         =   struct('type','VG400','gyroscope',[], 'gyrometre',[],'acc',[],'timeUTC',[],'timeRTMaps',[]); 
gyro        =   struct('type','KVH_ECORE_2100','gyrometre',[],'timeUTC',[],'timeRTMaps',[]);
topo        =   struct('type','Odometre','topo',[],'vitesse',[],'timeUTC',[],'timeRTMaps',[]);
compass     =   struct('type','KVH_C100','compass',[],'timeUTC',[],'timeRTMaps',[]);
rtk         =   struct('type','SAGITTA','x',[],'y',[],'z',[],'HDOP',[],'mode',[],'timeUTC',[],'timeRTMaps',[],'retard',0.0);

if AG132
    DataSynch.gps.type =         'AG132';                    % Type de capteur 
    DataSynch.gps.timeUTC =      GPS_AG132(:,1);             % Time UTC 
    DataSynch.gps.timeRTMaps =   GPS_AG132(:,2);             % Time RTMaps
    DataSynch.gps.x =            GPS_AG132(:,3);             % X
    DataSynch.gps.y =            GPS_AG132(:,4);             % Y
    DataSynch.gps.z =            GPS_AG132(:,5);             % Z
    DataSynch.gps.HDOP =         GPS_AG132(:,6);             % HDOP
    DataSynch.gps.mode =         GPS_AG132(:,7);             % mode
    DataSynch.gps.retard =       GPS_AG132(:,8);             % retard 
    DataSynch.gps.valide =       GPS_AG132(:,9);             % validité 
    DataSynch.gps.a =            GPS_AG132(:,10);             % a 
    DataSynch.gps.b =            GPS_AG132(:,11);             % b 
    DataSynch.gps.phi =           GPS_AG132(:,12)-pi/2;             % phi 
else
    DataSynch.gps.type =         'A12';                      % Type de capteur 
    DataSynch.gps.timeUTC =      GPS_A12(:,1);               % Time UTC 
    DataSynch.gps.timeRTMaps =   GPS_A12(:,2);               % Time RTMaps
    DataSynch.gps.x =            GPS_A12(:,3);               % X
    DataSynch.gps.y =            GPS_A12(:,4);               % Y
    DataSynch.gps.z =            GPS_A12(:,5);               % Z
    DataSynch.gps.HDOP =         GPS_A12(:,6);               % HDOP
    DataSynch.gps.mode =         GPS_A12(:,7);               % mode
    DataSynch.gps.retard =       GPS_A12(:,8);               % retard   
end;

DataSynch.rtk.type =         'SAGITTA';                    % Type de capteur
DataSynch.rtk.timeUTC =      GPS_Sagitta(:,1);             % Time UTC
DataSynch.rtk.timeRTMaps =   GPS_Sagitta(:,2);             % Time RTMaps
DataSynch.rtk.x =            GPS_Sagitta(:,3);             % X
DataSynch.rtk.y =            GPS_Sagitta(:,4);             % Y
DataSynch.rtk.z =            GPS_Sagitta(:,5);             % Z
DataSynch.rtk.HDOP =         GPS_Sagitta(:,6);             % HDOP
DataSynch.rtk.mode =         GPS_Sagitta(:,7);             % mode
DataSynch.rtk.retard =       GPS_Sagitta(:,8);             % retard

DataSynch.angleroue.timeUTC =      Braquage_Rad(:,1);      % Time UTC 
DataSynch.angleroue.timeRTMaps =   Braquage_Rad(:,2);      % Time RTMaps
DataSynch.angleroue.angle =        Braquage_Rad(:,3);      % Braquage des roues en radians

DataSynch.ins.timeUTC =      INS_VG400(:,1);               % Time UTC 
DataSynch.ins.timeRTMaps =   INS_VG400(:,2);               % Time RTMaps;
DataSynch.ins.gyroscope =    INS_VG400(:,3:4);             % angles en rad
DataSynch.ins.gyrometre =    [INS_VG400(:,5:7) INS_VG400(:,12)];             % vitesses anglulaires en rad/s
DataSynch.ins.acc =          INS_VG400(:,8:10);            % acceleration en m/s²

DataSynch.gyro.timeUTC =     INS_VG400(:,1);               % Time UTC 
DataSynch.gyro.timeRTMaps =  INS_VG400(:,2);               % Time RTMaps;
DataSynch.gyro.gyrometre =   [];	                          % vitesse angulaire de cap en rad/s	

DataSynch.topo.timeUTC =     Odometre(:,1);                % Time UTC 
DataSynch.topo.timeRTMaps =  Odometre(:,2);                % Time RTMaps;
DataSynch.topo.topo =        Odometre(:,3);                % distance parcourue

DataSynch.compass.timeUTC =     INS_VG400(:,1);            % Time UTC 
DataSynch.compass.timeRTMaps =  INS_VG400(:,1);            % Time RTMaps;
DataSynch.compass.compass =     [];	                       % angle en rad		

% Une fois la structure Data construite, on supprime les structures
% intermédiaires.
if AG132
    clear GPS_AG132;
else
    clear GPS_A12;
end;
clear GPS_Sagitta;
clear Braquage_Rad;
clear INS_VG400;
clear Gyro_KVH;
clear Odometre;
clear Compass_KVH
clear data;







