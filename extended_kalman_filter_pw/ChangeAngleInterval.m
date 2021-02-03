%****************************************************************************************
% ChangeAngleInterval
% Module de calcul pour passer des valeurs d'angle de l'intervalle 0 à 360° vers -90° à 90° 
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: ChangeAngleInterval.m,v $
% Date de creation : 2007/22/08
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/22/08 18:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%****************************************************************************************/
function [NewAngle] = ChangeAngleInterval(OldAngle);

Cadran = ceil(OldAngle/90);

switch Cadran
    case 1, NewAngle = OldAngle;
    case 2, Coef = inv([90.0 1.0; 270.0 1.0])*[-90.0; 90.0];
            NewAngle = OldAngle*Coef(1) + Coef(2);
    case 3, Coef = inv([90.0 1.0; 270.0 1.0])*[-90.0; 90.0];
            NewAngle = OldAngle*Coef(1) + Coef(2);
    case 4, Coef = inv([270.0 1.0; 360.0 1.0])*[-90.0; 0.0];
            NewAngle = OldAngle*Coef(1) + Coef(2);
    otherwise disp(' CE N''EST PAS POSSIBLE !!!');
end;

        

