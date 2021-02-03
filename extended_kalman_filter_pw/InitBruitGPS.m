%****************************************************************************************
% InitBruitGPS
% Module de calcul de la matrice de bruit GPS en fonction des ecarts types et de l'orientation
% de l'éllipse d'imprécision de la donnée GPS 
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: InitBruitGPS.m,v $
% Auteur           : Dominique Gruyer 										
%	
%****************************************************************************************/

function [Q_GPS] = InitBruitGPS( Valide, ModeGPS, SigmaA, SigmaB, Phi);

Phi = pi*Phi/180;

if Valide
    switch ModeGPS
        case 1,
            % Mode GPS naturel
            if (SigmaA > 0.0)
                [Phi] = ChangeAngleInterval(Phi);
                VarianceA = SigmaA^2*cos(Phi)^2+SigmaB^2*sin(Phi)^2;
                VarianceB = SigmaA^2*sin(Phi)^2+SigmaB^2*cos(Phi)^2;
                CoVarianceAB = (SigmaA^2-SigmaB^2)*cos(Phi)*sin(Phi);             
              % CoVarianceAB = -( (VarianceB - VarianceA)*tan(2*(Phi*pi/180) ))/2;
                Q_GPS	=	[   VarianceA         CoVarianceAB;
                                CoVarianceAB  	VarianceB];
            else
                Q_GPS	=	[   5^2  	0;
                                0  	5^2];
            end;
        case 2,
            % Mode GPS differentiel
            if (SigmaA > 0.0)
                [Phi] = ChangeAngleInterval(Phi);
                VarianceA = SigmaA^2*cos(Phi)^2+SigmaB^2*sin(Phi)^2;
                VarianceB = SigmaA^2*sin(Phi)^2+SigmaB^2*cos(Phi)^2;
                CoVarianceAB = (SigmaA^2-SigmaB^2)*cos(Phi)*sin(Phi);             
               % CoVarianceAB = -( (VarianceB - VarianceA)*tan(2*(Phi*pi/180) ))/2; 
               
                Q_GPS	=	[   VarianceA         CoVarianceAB;
                                CoVarianceAB  	VarianceB];
            else
                Q_GPS	=	[   .1^2      0;
                                0   	.1^2];
            end;
        case 0,
            % Masquage
            Q_GPS	=	[   500^2 	0;
                            0   	500^2];
        otherwise,
            disp('Problème de mode du GPS !!! MODE INCONNUE');
            Q_GPS	=	[   500^2 	0;
                            0   	500^2];
    end;
else
    Q_GPS	=	[   500^2 	0;
                    0   	500^2];
end;
