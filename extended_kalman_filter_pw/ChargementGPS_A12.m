%****************************************************************************************
% ChargementGPS_A12
% Module de chargement des données du capteur GPS A12
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: ChargementGPS_A12.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données du capteur:
%                           GPS A12
%****************************************************************************************/
function [GPS_A12] = ChargementGPS_A12(GPS_A12,Ref)
% La sortie de cette fonction fournie une matrice avec:
% Colonne1: Temps (Temps RTMaps)
% Colonne2: Coordonnées en X
% Colonne3: Coordonnées en Y
% Colonne4: Coordonnées en Z
% Colonne5: HDOP
% Colonne6: Mode GPS, 1 gps naturel, 2 différentiel EGNOS, 0 masquage 

format long;

% Shcom9.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data From Ashtech A12 GPS Receiver
% Time | latitude (deg) | longitude (deg) | Altitude (m) | Speed over Ground (km/h) | Vertical Speed (km/h) | PDOP | HDOP | VDOP | TDOP | Number of SVs

load SensorsData/Log_com9;
disp(' Chargement A12 fait !!');
% Chargement du temps (Temps UTC en microsecondes)
GPS_A12 = [GPS_A12 SHcom9(:,1)];

% Calcul du temps (Temps RTMaps en microsecondes)
% Reference de temps UTC et RTMaps en microseconde
Time_UTC = 1132760286184009.00; % pris dans le fichier AG132_GGA
Time_RTMaps = 36448999;         % pris dans le fichier AG132_GGA
% On ramène le temps de ce capteur dans le temps RTMaps
Time = (SHcom9(:,1)*Time_RTMaps)/Time_UTC;
GPS_A12 = [GPS_A12 Time];

% Chargement des coordonnées cartésiens
% G2C_RGF   transforme les coordonnees geographiques en cartesiennes pour le RGF
%	        ces coordonnees peuvent etre scalaires ou vectorielles
%	        entrées: longitude,latitude,h en rad et m
%	        sorties: X,Y,Z en m
VecteurX = [];
VecteurY = [];
% conversion des latitudes et longitudes de degré en radian
SHcom9(:,2) = (SHcom9(:,2).*pi)./180;
SHcom9(:,3) = (SHcom9(:,3).*pi)./180;
Methode1 = 1;

if Methode1
    for i=1:size(SHcom9,1)
        [X,Y] = ConverterLL2XY(SHcom9(i,2),SHcom9(i,3));
        VecteurX = [VecteurX; X];
        VecteurY = [VecteurY; Y];
    end;
    VecteurX = VecteurX - Ref(1,1);
    VecteurY = VecteurY - Ref(1,2);
    VecteurZ = SHcom9(:,4) - Ref(1,3);
    GPS_A12 = [GPS_A12 VecteurX VecteurY VecteurZ];
else
    [X,Y,Z] = g2c_rgf((SHcom9(:,2)*pi)/180,(SHcom9(:,3)*pi)/180,SHcom9(:,4));
    % [xt,yt,zt] = cart2tan(X(1),Y(1),Z(1),X,Y,Z);
    % GPS_A12 = [GPS_A12 xt' yt' zt'];
    GPS_A12 = [GPS_A12 X Y Z];
end;

% HDOP: Dilution Of Precision pour la composante planisférique
% HDOP = sqrt(Rho_est^2 + Rho_nord^2)/Rho_mesure
GPS_A12 = [GPS_A12 SHcom9(:,8)];

% Coordonnées du mode (nombre de satellites visibles
GPS_A12 = [GPS_A12 SHcom9(:,11)];
disp(' Création de la matrice de données _GPS_A12 fait !!');

% Chargement du retard entre la reception du signal et la mise à
% disposition (en seconde)
Retard = zeros(size(SHcom9(:,4),1),1) + .150;
GPS_A12 = [GPS_A12 Retard];
clear Retard;

clear SHcom9;