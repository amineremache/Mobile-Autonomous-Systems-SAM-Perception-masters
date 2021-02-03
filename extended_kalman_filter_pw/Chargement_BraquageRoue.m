%****************************************************************************************
% Chargement_BraquageRoue
% Module de chargement des données du capteur 'angle au volant' 
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: Chargement_BraquageRoue.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des données du capteur:
%                           Angle au volant
%****************************************************************************************/
function [Braquage_Roue] = Chargement_BraquageRoue(Braquage_Roue);

%BraquageRadw.m :
%
% Fichier Texte, directement exploitable sous Matlab.
% Ce fichier contient les données traitées du codeur optique de la colonne de direction : le braquage des roues en radians.
%
%   Colonne 1 :
%	    Temps UTC en microsecondes écoulées depuis le premier janvier 1970 minuit.
%       Ce temps est celui du moment où les données sont disponibles dans Maps, après acquisition et traitement.
%   Colonne 2 :
%       Temps MAPS en microsecondes.
%       Ce temps est celui du moment où les données sont disponibles dans Maps, après acquisition et traitement.
%   Colonne 3 :
%       Temps MAPS en microsecondes.
%   Colonne 4 :
%	    Braquage des roues en radians. Négatif lorsque le véhicule tourne à gauche, positif lorsque le véhicule tourne à droite.
%=====================================================================

load SensorsData/BraquageRadw;
Braquage_Roue = [Braquage_Roue Braquage_Rad(:,1) Braquage_Rad(:,2) Braquage_Rad(:,4)];

clear Braquage_Rad;