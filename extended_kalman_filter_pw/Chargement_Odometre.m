%****************************************************************************************
% Chargement_Odometre
% Module de chargement des données du capteur Odometre 
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: Chargement_Odometre.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données du capteur:
%                           Odometre
%****************************************************************************************/
function [Odometre] = Chargement_Odometre(Odometre);
%==========================================================
% Chargement des données odometrique
% log_com6.m :
% Fichier Texte, directement exploitable sous Matlab. 
% Fichier SENSORHUB contenant (voir son entête) : Data from Vehicle Odometer
% Time of Tick Rising Edge | Number of ticks (modulo 65536) - 1 tick estimated to 19.54cm -
%==========================================================

load SensorsData/Log_com6;

% Reference de temps UTC et RTMaps en microseconde
Time_UTC = 1132760286184009.00; % pris dans le fichier AG132_GGA
Time_RTMaps = 36448999;         % pris dans le fichier AG132_GGA
% On ramène le temps de ce capteur dans le temps RTMaps
Time = (SHcom6(:,1)*Time_RTMaps)/Time_UTC;

Odometre = [Odometre SHcom6(:,1) Time SHcom6(:,2)];

clear SHcom6;