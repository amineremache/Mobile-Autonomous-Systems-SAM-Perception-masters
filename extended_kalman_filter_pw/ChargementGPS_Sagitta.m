%****************************************************************************************
% ChargementGPS_Sagitta
% Module de chargement des donn�es du capteur GPS RTK Sagitta
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: ChargementGPS_Sagitta.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Chargement des donn�es du capteur:
%                           GPS AG132
%****************************************************************************************/
function [GPS_Sagitta] = ChargementGPS_Sagitta(GPS_Sagitta,Ref)
% La sortie de cette fonction fournie une matrice avec:
% Colonne1: Temps (Temps RTMaps)
% Colonne2: Coordonn�es en X
% Colonne3: Coordonn�es en Y
% Colonne4: Coordonn�es en Z
% Colonne5: HDOP
% Colonne6: Mode GPS, 1 gps naturel, 2 diff�rentiel EGNOS, 0 masquage 
% Colonne7: Retard entre la reception du signal par le GPS et sa mise � disposition

format long;
%==========================================================================
% fichier AG132ZDAw.m :
%
% Fichier Texte, directement exploitable sous Matlab.
% Ce fichier contient les donn�es extraites des trames ZDA envoy�es par le GPS RTK Thales Sagitta 
% (r�cepteur du LIVIC).
%   Colonne 1 :
%       Temps UTC en microsecondes �coul�es depuis le premier janvier 1970 minuit.
%       Ce temps est celui du moment o� les donn�es sont disponibles dans Maps, 
%       apr�s acquisition et traitement.
%   Colonne 2 :
%       Temps MAPS en microsecondes.
%       Ce temps est celui du moment o� les donn�es sont disponibles dans Maps, 
%       apr�s acquisition et traitement.
%   Colonne 3 :
%       Temps MAPS en microsecondes.
%   Colonne 4 :
%       Temps UTC. hhmmss.ss en Heures Minutes Secondes.
%       Ce temps est celui contenu dans la trame.
%       Ex : 163028.1600000 <-> 16h30min28.16s
%       Il ne faut pas tenir compte de la partie d�cimale des secondes. 
%       La valeur enti�re correspond � l'heure d'envoi du PPS.
%   Colonne 5 :
%	    Jour du mois [1-31].
%   Colonne 6 :
%	    Mois de l'ann�e [1-12] 1 janvier, 12 d�cembre. =11.
%   Colonne 7 :
%	    Ann�e. =2005.
%   Colonne 8 :
%	    D�calage en heure de la zone. =0 ! Nota : � 16h UTC, nos montres indiquaient 17h.
%   Colonne 9 :
%	    D�calage en minutes de la zone [0-59]. =0.
%==========================================================================
disp(' Chargement SAGITTA_ZDAw fait !!');
load SensorsData/SAGITTAZDAw;

%==========================================================================
% AG132GGAw.m :
% 
% Fichier Texte, directement exploitable sous Matlab.
% Ce fichier contient les donn�es extraites des trames GGA envoy�es par le GPS Trimble AG132 PvfilterON (r�cepteur du LCPC).
%   Colonne 1 :
%       Temps UTC en microsecondes �coul�es depuis le premier janvier 1970 minuit.
%       Ce temps est celui du moment o� les donn�es sont disponibles dans Maps, apr�s acquisition et traitement.
%   Colonne 2 :
%       Temps MAPS en microsecondes.
%       Ce temps est celui du moment o� les donn�es sont disponibles dans Maps, apr�s acquisition et traitement.
%   Colonne 3 :
%       Temps MAPS en microsecondes.
%   Colonne 4 :
%       Temps UTC. hhmmss.ss en Heures Minutes Secondes.
%       Ce temps est celui contenu dans la trame.
%       Ex : 163028.1600000 <-> 16h30min28.16s
%   Colonne 5 :
%	    Latitude WGS84 en degr�s.
%   Colonne 6 :
%	    Longitude WGS84 en degr�s.
%   Colonne 7 :
%	    Altitude WGS84 en m�tres.
%   Colonne 8 :
%	    HDOP.
%   Colonne 9 :
%	    Nombre de satellite visible.
%==========================================================================
load SensorsData/SAGITTAGGAw;
disp(' Chargement SAGITTA_GCAw fait !!');
% Chargement du temps (Temps UTC en microsecondes)
GPS_Sagitta = [GPS_Sagitta SAGITTA_GGA(:,1)];

% Chargement du temps (Temps RTMaps en microsecondes)
GPS_Sagitta = [GPS_Sagitta SAGITTA_GGA(:,2)];

% Chargement des coordonn�es cart�siens
% G2C_RGF   transforme les coordonnees geographiques en cartesiennes pour le RGF
%	        ces coordonnees peuvent etre scalaires ou vectorielles
%	        entr�es: longitude,latitude,h en rad et m
%	        sorties: X,Y,Z en m
VecteurX = [];
VecteurY = [];
% conversion des latitudes et longitudes de degr� en radian
SAGITTA_GGA(:,5) = (SAGITTA_GGA(:,5).*pi)./180;
SAGITTA_GGA(:,6) = (SAGITTA_GGA(:,6).*pi)./180;
Methode1 = 1;
ReferencePiste = 0;
if Methode1
    for i=1:size(SAGITTA_GGA,1)
        [X,Y] = ConverterLL2XY(SAGITTA_GGA(i,5),SAGITTA_GGA(i,6));
        VecteurX = [VecteurX; X];
        VecteurY = [VecteurY; Y];
    end;
    VecteurX = VecteurX - Ref(1,1);
    VecteurY = VecteurY - Ref(1,2);
    VecteurZ = SAGITTA_GGA(:,7) - Ref(1,3);
    GPS_Sagitta = [GPS_Sagitta VecteurX VecteurY VecteurZ];
else
    [X,Y,Z] = g2c_rgf((SAGITTA_GGA(:,5)*pi)/180,(SAGITTA_GGA(:,6)*pi)/180,SAGITTA_GGA(:,7));
    % [xt,yt,zt] = cart2tan(X(1),Y(1),Z(1),X,Y,Z);
    % GPS_A12 = [GPS_A12 xt' yt' zt'];
    GPS_Sagitta = [GPS_Sagitta X Y Z];
end;

% HDOP: Dilution Of Precision pour la composante planisf�rique
% HDOP = sqrt(Rho_est^2 + Rho_nord^2)/Rho_mesure
GPS_Sagitta = [GPS_Sagitta SAGITTA_GGA(:,8)];

% Coordonn�es du mode
GPS_Sagitta = [GPS_Sagitta SAGITTA_GGA(:,9)];
disp(' Cr�ation de la matrice de donn�es _GPS_AG132 fait !!');

% Chargement du retard entre la reception du signal et la mise �
% disposition (en seconde)
Retard = SAGITTA_GGA(:,4) - floor(SAGITTA_GGA(:,4));
GPS_Sagitta = [GPS_Sagitta Retard];
clear Retard;


clear AG132_ZDA;
clear AG132_GGA;
clear AG132_PPSUTC;
clear VecteurX;
clear VecteurY;
clear VecteurZ;
