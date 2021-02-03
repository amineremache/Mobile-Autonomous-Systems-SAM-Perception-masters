%****************************************************************************************
% Chargement_Compass_KVH
% Module de chargement des données du capteur Boussole KVH C100 
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: Chargement_Compass_KVH.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données du capteur:
%                           Boussole KVH C100
%****************************************************************************************/
function [Compass_KVH] = Chargement_Compass_KVH(Compass_KVH);

%==========================================================
% Chargement des données de la boussole KVH
% log_com2.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data From KvH C100 Compass
% Time | Angle (deg)
% Le sortie de cette fonction donne:
% Time (UTC) | Time (RTMaps) | Angle (deg) 
%==========================================================
load SensorsData/Log_com2;

% Reference de temps UTC et RTMaps en microseconde
Time_UTC = 1132760286184009.00; % pris dans le fichier AG132_GGA
Time_RTMaps = 36448999;         % pris dans le fichier AG132_GGA
% On ramène le temps de ce capteur dans le temps RTMaps
Time = (SHcom2(:,1)*Time_RTMaps)/Time_UTC;

Compass_KVH = [Compass_KVH SHcom2(:,1) Time SHcom2(:,2)];

clear SHcom2;