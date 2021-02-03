[XRef,YRef] = ConverterLL2XY(((48+47/60+11.07122/3600)*pi)/180, ((2+5/60+32.15779/3600)*pi)/180);
ZRef = 216.937;
ReferenceGPS = [ XRef YRef ZRef];
[pisteRoute, pisteValdOr] = ChargementPistesReferences(ReferenceGPS, 1);
load('ResultatFiltres\Sans_ResultatGPSINSTopoEKF3.mat');
count = size(DonneesLocalisationEKF,2);
X1_E = zeros(count, 3);
for i = 1:count
    x_E = DonneesLocalisationEKF(i).X_E(1);
    y_E = DonneesLocalisationEKF(i).X_E(2);
    z_E = DonneesLocalisationEKF(i).X_E(3);
    X1_E(i, :) = [x_E, y_E, z_E];
end

plot(pisteRoute.xd, pisteRoute.yd, 'black'); hold on;
plot(pisteRoute.xc, pisteRoute.yc, 'b'); hold on;
plot(pisteRoute.xg, pisteRoute.yg, 'black'); hold on;
plot(pisteValdOr.xd, pisteValdOr.yd, 'black'); hold on;
plot(pisteValdOr.xc, pisteValdOr.yc, 'r'); hold on;
plot(pisteValdOr.xg, pisteValdOr.yg, 'black'); hold on;
plot(X1_E(:,1), X1_E(:,2), 'g');

% % chargement de la matrice de position estimé sans les donée GPS :
% 
% % load('ResultatFiltres\ResultatGPSINSTopoEKF3_1.mat');
% count = size(DonneesLocalisationEKF,2);
% 
% % Extraction des coordonnées de la matrice de structure : 
% 
% X2_E = zeros(count, 3);
% 
% for i = 1:count
%     x_E = DonneesLocalisationEKF(i).X_E(1);
%     y_E = DonneesLocalisationEKF(i).X_E(2);
%     z_E = DonneesLocalisationEKF(i).X_E(3);
%     X2_E(i, :) = [x_E, y_E, z_E];
% end
% figure;
% 
% % tracer du trajet : carte routiere et cal d'Or : 
% 
% plot(pisteRoute.xd, pisteRoute.yd, 'g');
% hold on
% plot(pisteRoute.xc, pisteRoute.yc, 'r');
% hold on
% plot(pisteRoute.xg, pisteRoute.yg, 'g');
% hold on
% plot(pisteValdOr.xd,   pisteValdOr.yd, 'g');
% hold on
% plot(pisteValdOr.xc, pisteValdOr.yc, 'r');
% hold on
% plot(pisteValdOr.xg, pisteValdOr.yg, 'g');
% hold on
% 
% % position de l'estimateur EKF sans GPS : 
% plot(X2_E(:,1), X2_E(:,2), 'b');
