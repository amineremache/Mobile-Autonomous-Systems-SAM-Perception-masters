%****************************************************************************************
% Chargement_Gyro_KVH
% Module de chargement des données du capteur Gyrometre KVH ECore 2100 Fiber Optic
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: Chargement_Gyro_KVH.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données du capteur:
%                           Gyrometre KVH ECore 2100 Fiber Optic
%****************************************************************************************/
function [Gyro_KVH] = Chargement_Gyro_KVH(Gyro_KVH);

%==========================================================
% log_com4.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data From KvH ECore 2100 Fiber Optic Gyrometer
% Time | Rotation Rate (deg/s) | Temperature (°C)
%==========================================================
load SensorsData/Log_com4;

% Reference de temps UTC et RTMaps en microseconde
Time_UTC = 1132760286184009.00; % pris dans le fichier AG132_GGA
Time_RTMaps = 36448999;         % pris dans le fichier AG132_GGA
% On ramène le temps de ce capteur dans le temps RTMaps
Time = (SHcom4(:,1)*Time_RTMaps)/Time_UTC;

Gyro_KVH = [Gyro_KVH SHcom4(:,1) Time SHcom4(:,2:3)];

clear SHcom4;