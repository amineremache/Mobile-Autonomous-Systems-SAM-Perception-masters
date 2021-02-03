%****************************************************************************************
% EstimationKalmanNL
% Module de mise à jour et de correction du vecteur d'état  
% 
% Fichier          : $RCSfile: EstimationKalmanNL.m,v $
% Auteur           : Dominique Gruyer 						
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Calcul des étapes suivantes:
%                               Calcul du résidu
%								Calcul du gain
%								Calcul de la nouvelle estimée 
%								Calcul de la nouvelle matrice de variance-covariance estimée
%************************************************************************************************/
function [X_E,P_E,Sk]=EstimationKalmanNL(P_P,Hk,X_P,Y_GPS,Q_GPS); 

% P_P: Matrice de variance covariance sur la prediction
% Hk: Matrice de mesure. Cette matrice est une matrice de transfert entre la mesure et le vecteur d'état
% X_P: vecteur d'état prédit
% Y_GPS: donnée GPS, (X,Y)
% Q_GPS: bruit de GPS
         
 
 % calcule du Residu :
 
 Sk = Hk * P_P * Hk' + Q_GPS;
 
 % gain de kalman :
 
 Kk = P_P * Hk' * inv(Sk);

 % Nouvelle estimation de l'etat :
 
X_E = X_P + Kk * (Y_GPS - X_P(1:2));

%nouvelle matrice de covarience 
P_E = (eye(3) - Kk*Hk) * P_P * ( eye(3) - Kk*Hk)' + Kk*Q_GPS*Kk';