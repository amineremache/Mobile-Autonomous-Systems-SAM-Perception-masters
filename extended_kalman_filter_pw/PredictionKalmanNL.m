%****************************************************************************************
% PredictionKalmanNL
% Module de prédiction de l'état du système  
% 
% Fichier          : $RCSfile: PredictionKalmanNL.m,v $
% Auteur           : Dominique Gruyer 						
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Calcul des étapes suivantes:
%                               Prédiction de l'état du système
%								Calcul de la nouvelle matrice de variance-covariance prédite
%************************************************************************************************/
function [X_P,P_P]=PredictionKalmanNL(var_S,var_teta,Fk,X_E,P_E,Q_systeme,AngleRoue);

if (var_S == 0)
    P_P =   P_E;
    X_P =   X_E;
else
% calcul du vecteur d'état prédit X(k/k-1)
%==================================================
X_P = [X_E(1) + var_S*cos(X_E(3) + (var_teta/2))*cos(AngleRoue); ...
       X_E(2) + var_S*sin(X_E(3) + (var_teta/2))*cos(AngleRoue); ...
       X_E(3) + var_teta];
       


% calcul de la variance de la prediction P(k/k-1)
%==================================================

P_P = Fk * P_E * Fk' +Q_systeme;

end