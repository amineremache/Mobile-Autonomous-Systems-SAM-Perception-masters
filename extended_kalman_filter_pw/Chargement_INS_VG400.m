%****************************************************************************************
% Chargement_INS_VG400
% Module de chargement des données du capteur INS Crowsbow VG400
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: Chargement_INS_VG400.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données du capteur:
%                           INS Crowsbow VG400
%****************************************************************************************/
function [INS_VG400] = Chargement_INS_VG400(INS_VG400);

%==========================================================
% Chargement des données de la centrale inertielle : VG400
% Shcom3.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : 
% Data From CrossBow DMU-HDX INS equivalent to VG400-CC-100
% Time (microseconde) | Angle Pitch/Roll (deg) | AngleRate X,Y,Z (deg/s) | Accel X,Y,Z (G) | Temp (°C)
%==========================================================
load SensorsData/Log_com3;

% Reference de temps UTC et RTMaps en microseconde
Time_UTC = 1132760286184009.00; % pris dans le fichier AG132_GGA
Time_RTMaps = 36448999;         % pris dans le fichier AG132_GGA
% On ramène le temps de ce capteur dans le temps RTMaps
Time = (SHcom3(:,1)*Time_RTMaps)/Time_UTC;

INS_VG400 = [INS_VG400 SHcom3(:,1) Time SHcom3(:,2:10)];

clear SHcom3;