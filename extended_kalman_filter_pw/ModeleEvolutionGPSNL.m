
%****************************************************************************************
% ModeleEvolutionGPSNL
% Module de calcul des différentes matrices et structures utilisées par l'EKF 
% 
% Fichier          : $RCSfile: ModeleEvolutionGPSNL.m,v $
% Auteur           : Dominique Gruyer 									
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Calcul des étapes suivantes:
%                               matrice jacobienne du modele d'évolution: Fk = dfk/dxk
%                               matrice jacobienne du modele d'évolution: Bk = dfk/duk
%                               matrice de mesure: Hk
%                               matrice de bruit d'état et de mesure
%****************************************************************************************/
function [Fk,Hk,Bk,Q_systeme,Q_GPS]=ModeleEvolutionGPSNL(var_S,var_teta_c,teta_c,VarSysteme,ModeGPS,Valide,SigmaA,SigmaB,Phi,Psi);

   %================================================================         
   % DEFINITION DU MODELE D'EVOLUTION ET DE LA PREMIERE PREDICTION
   %================================================================
	% calcul de la premiere position prédite du véhicule
   %======================================================
   R = 0.3;						% rayon de la roue
   E = 1;						% longueur de l'essieu
   pas_codeur=.1954;
   
	% matrice jacobienne du modele d'évolution: Fk = dfk/dxk
	%========================================================

   Fk = [1, 0, -var_S*sin(teta_c +(var_teta_c/2))*cos(Psi); ...
         0, 1,  var_S*cos(teta_c +(var_teta_c/2))*cos(Psi); ...
         0, 0, 1];
	
	
      
	% matrice jacobienne du modele d'évolution: Bk = dfk/duk
	%========================================================

    Bk = [cos(teta_c +(var_teta_c/2))*cos(Psi), (-var_S/2)*sin(teta_c +(var_teta_c/2))*cos(Psi);
          sin(teta_c +(var_teta_c/2))*cos(Psi), (var_S/2) *cos(teta_c +(var_teta_c/2))*cos(Psi);
          0, 1];
	
	
    % matrice de mesure: Hk 
	%========================================================

   Hk = [1, 0, 0;
         0, 1, 0];
   
  
   %========================================================         
   % CALCUL DE LA MATRICE DE BRUIT SUR L'ENTREE DU SYSTEME
   %========================================================
      
   Q_systeme = [ VarSysteme(1)^2, 0, 0;
                0, VarSysteme(2)^2,  0;
                0, 0, VarSysteme(3)^2];

   %================================================================
   % 			Construction de la matrice de bruit du GPS
   % Cette matrice est construite à partir des sigmas a et b et de la
   % rotation fournie par le GPS dans le cas où l'indicateur de validité 
   % d'une mesure est à 1
   %=================================================================
   %  Mode GPS, 1 gps naturel, 2 différentiel EGNOS, 0 masquage
   %  Valide, 0 et 1
   %================================================================
     
    Q_GPS = InitBruitGPS( Valide, ModeGPS, SigmaA, SigmaB, Phi);