%****************************************************************************************
% ChargementDonneesFUDOLO
% Module de chargement des données des capteurs FUDOLO
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: ChargementDonneesFUDOLO.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données des capteurs:
%                           topometre, 
%                           INS VG400,
%                           Compass KVH,
%                           Gyrometre KVH,
%                           GPS AG132 et A12
%****************************************************************************************/
function [Data ] = ChargementDonneesFUDOLO(Data,PisteValdOr,PisteRoutiere);

Data = struct('gps',[],'angleroue',[],'ins',[],'gyro',[],'topo',[],'compass',[],'vision',[],'rtk',[]);
Affichage = 1;

% PisteValdOr3D      -> Coordonnées de la piste du val d'or   ( Variable PisteValDOr )
% PisteRoutiere3D    -> Coordonnées de la piste routière      ( Variable PisteRoutiere )

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
[GPS_AG132 ] = ChargementGPS_AG132([],PisteRoutiere.ref);
disp(' Sortie chargement GPS AG132 ');

%===========================================
% Chargement des données GPS: A12
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
disp(' Entrée chargement GPS A12 ');
[GPS_A12 ] = ChargementGPS_A12([],PisteRoutiere.ref);
disp(' Sortie chargement GPS A12 ');


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
Braquage_Rad = Chargement_BraquageRoue([]);
disp(' Sortie chargement Braquage roue ');

%==========================================================
% Chargement des données de la centrale inertielle : VG400
% log_com3.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : 
% Data From CrossBow DMU-HDX INS equivalent to VG400-CC-100
% Time (UTC)| Angle Pitch/Roll (deg) | AngleRate X,Y,Z (deg/s) | Accel X,Y,Z (G) | Temp (°C)
% La sortie de cette fonction donne:
% Time (UTC)| Time (RTMaps)| Angle Pitch/Roll (deg) | AngleRate X,Y,Z (deg/s) | Accel X,Y,Z (G) | Temp (°C)
% La conversion est réalisée en utilisant les données de temps du fichier AG132_GGA
%==========================================================
disp(' Entrée chargement INS VG400 ');
INS_VG400 = Chargement_INS_VG400([]);
disp(' Sortie chargement INS VG400 ');

%==========================================================
% Chargement des données du gyromètre : KVH
% log_com4.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data From KvH ECore 2100 Fiber Optic Gyrometer
% Time (UTC- micosec) | Rotation Rate (deg/s) | Temperature (°C)
% Le sortie de cette fonction donne:
% Time (UTC) | Time (RTMaps) | Rotation Rate (deg/s) | Temperature (°C)
% La conversion est réalisée en utilisant les données de temps du fichier AG132_GGA
%==========================================================================
disp(' Entrée chargement Gyro KVH ');
Gyro_KVH = Chargement_Gyro_KVH([]);
disp(' Sortie chargement Gyro KVH ');

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
Odometre = Chargement_Odometre([]);
disp(' Sortie chargement Odometre ');

%==========================================================
% Chargement des données de la boussile
% log_com2.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data From KvH C100 Compass
% Time | Angle (deg)
% Le sortie de cette fonction donne:
% Time (UTC) | Time (RTMaps) | Angle (deg) 
%==========================================================
disp(' Entrée chargement boussole KVH');
Compass_KVH = Chargement_Compass_KVH([]);
disp(' Sortie chargement boussole KVH');


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
    Data.gps.type =         'AG132';                    % Type de capteur 
    Data.gps.timeUTC =      GPS_AG132(:,1);             % Time UTC 
    Data.gps.timeRTMaps =   GPS_AG132(:,2);             % Time RTMaps
    Data.gps.x =            GPS_AG132(:,3);             % X
    Data.gps.y =            GPS_AG132(:,4);             % Y
    Data.gps.z =            GPS_AG132(:,5);             % Z
    Data.gps.HDOP =         GPS_AG132(:,6);             % HDOP
    Data.gps.mode =         GPS_AG132(:,7);             % mode
    Data.gps.retard =       GPS_AG132(:,8);             % retard 
    Data.gps.valide =       [];                         % donnée valide 
    Data.gps.a =            0;                          % sigma a (si 0 alors non fournie)
    Data.gps.b =            0;                          % sigma b (si 0 alors non fournie) 
    Data.gps.phi =          0;                          % phi   
else
    Data.gps.type =         'A12';                      % Type de capteur 
    Data.gps.timeUTC =      GPS_A12(:,1);               % Time UTC 
    Data.gps.timeRTMaps =   GPS_A12(:,2);               % Time RTMaps
    Data.gps.x =            GPS_A12(:,3);               % X
    Data.gps.y =            GPS_A12(:,4);               % Y
    Data.gps.z =            GPS_A12(:,5);               % Z
    Data.gps.HDOP =         GPS_A12(:,6);               % HDOP
    Data.gps.mode =         GPS_A12(:,7);               % mode
    Data.gps.retard =       GPS_A12(:,8);               % retard   
    Data.gps.valide =       [];                         % donnée valide 
    Data.gps.a =            0;                          % sigma a (si 0 alors non fournie)
    Data.gps.b =            0;                          % sigma b (si 0 alors non fournie) 
    Data.gps.phi =          0;                          % phi   
end;

Data.rtk.type =         'SAGITTA';                    % Type de capteur
Data.rtk.timeUTC =      GPS_Sagitta(:,1);             % Time UTC
Data.rtk.timeRTMaps =   GPS_Sagitta(:,2);             % Time RTMaps
Data.rtk.x =            GPS_Sagitta(:,3);             % X
Data.rtk.y =            GPS_Sagitta(:,4);             % Y
Data.rtk.z =            GPS_Sagitta(:,5);             % Z
Data.rtk.HDOP =         GPS_Sagitta(:,6);             % HDOP
Data.rtk.mode =         GPS_Sagitta(:,7);             % mode
Data.rtk.retard =       GPS_Sagitta(:,8);             % retard

Data.angleroue.timeUTC =      Braquage_Rad(:,1);        % Time UTC 
Data.angleroue.timeRTMaps =   Braquage_Rad(:,2);        % Time RTMaps
Data.angleroue.angle =        Braquage_Rad(:,3);        % Braquage des roues en radians

Data.ins.timeUTC =      INS_VG400(:,1);                 % Time UTC 
Data.ins.timeRTMaps =   INS_VG400(:,2);                 % Time RTMaps;
Data.ins.gyroscope =    (INS_VG400(:,3:4)*pi)/180;      % angles en rad
Data.ins.gyrometre =    (INS_VG400(:,5:7)*pi)/180;      % vitesses anglulaires en rad/s
Data.ins.acc =          INS_VG400(:,8:10);

Data.gyro.timeUTC =     Gyro_KVH(:,1);                  % Time UTC 
Data.gyro.timeRTMaps =  Gyro_KVH(:,2);                  % Time RTMaps;
Data.gyro.gyrometre =   (Gyro_KVH(:,3)*pi)/180;	        % vitesse angulaire de cap en rad/s	

Data.topo.timeUTC =     Odometre(:,1);                  % Time UTC 
Data.topo.timeRTMaps =  Odometre(:,2);                  % Time RTMaps;
Data.topo.topo =        Odometre(:,3);

Data.compass.timeUTC =     Compass_KVH(:,1);            % Time UTC 
Data.compass.timeRTMaps =  Compass_KVH(:,2);            % Time RTMaps;
Data.compass.compass =     (Compass_KVH(:,3)*pi)/180;	% angle en rad		

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








