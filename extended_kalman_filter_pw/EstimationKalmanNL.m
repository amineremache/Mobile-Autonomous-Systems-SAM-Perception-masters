%****************************************************************************************
% EstimationKalmanNL
% Module de mise � jour et de correction du vecteur d'�tat  
% 
% Fichier          : $RCSfile: EstimationKalmanNL.m,v $
% Auteur           : Dominique Gruyer 						
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Calcul des �tapes suivantes:
%                               Calcul du r�sidu
%								Calcul du gain
%								Calcul de la nouvelle estim�e 
%								Calcul de la nouvelle matrice de variance-covariance estim�e
%************************************************************************************************/
function [X_E,P_E,Sk]=EstimationKalmanNL(P_P,Hk,X_P,Y_GPS,Q_GPS); 

% P_P: Matrice de variance covariance sur la prediction
% Hk: Matrice de mesure. Cette matrice est une matrice de transfert entre la mesure et le vecteur d'�tat
% X_P: vecteur d'�tat pr�dit
% Y_GPS: donn�e GPS, (X,Y)
% Q_GPS: bruit de GPS
         
 
 % calcule du Residu :
 
 Sk = Hk * P_P * Hk' + Q_GPS;
 
 % gain de kalman :
 
 Kk = P_P * Hk' * inv(Sk);

 % Nouvelle estimation de l'etat :
 
X_E = X_P + Kk * (Y_GPS - X_P(1:2));

%nouvelle matrice de covarience 
P_E = (eye(3) - Kk*Hk) * P_P * ( eye(3) - Kk*Hk)' + Kk*Q_GPS*Kk';