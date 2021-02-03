%% CREATION DE DEUX SOURCES AVEC BRUIT 

% Deux sources à deux classes (carrés au milieu d'un autre) 
class_size=[128 64];

%Generer deux distributions gaussiennes pour le bruit
sigma = [0.2 0.4];% tester sigma = [0.3 0.3] (faible bruit), sigma = [0.6 0.6] (fort bruit), sigma = [0.3 0.6] (seconde source a afaiblir)
disb1=sigma(1)*randn(class_size(1)); 
disb2=sigma(2)*randn(class_size(1)); 

% Creation de la verite terrain
mu_cl=[0.25 0.75];
I2=mu_cl(1)*ones(class_size(1)); 
I2((class_size(1)-class_size(2))/2:(class_size(1)+class_size(2))/2-1,...
    (class_size(1)-class_size(2))/2:(class_size(1)+class_size(2))/2-1)=mu_cl(2)*ones(class_size(2));

% Ajout du bruit 
I1=I2 + disb1;
I2=I2 + disb2;

% CHOIX 1 : Normalisation pour qu'on ait des sources entre 0 et 1. 
% min1=min(min(I1));
% max1=max(max(I1));
% min2=min(min(I2));
% max2=max(max(I2));
% dyn1=max1-min1;
% dyn2=max2-min2;
% I1=(I1-min1)/dyn1;
% I2=(I2-min2)/dyn2;

% CHOIX 2 :  Ne garder que les valeurs entre zero et un 
 I1(I1<0)=0;
 I2(I2<0)=0;
 I1(I1>1)=1;
 I2(I2>1)=1;

% Affichage 
fontsIm = 20;
fontwIm = 'bold';
figure;

subplot(1,2,1)
imshow(I1);
title('Source 1','fontsize',fontsIm,'fontweight',fontwIm);
subplot(1,2,2)
imshow(I2);
title('Source 2','fontsize',fontsIm,'fontweight',fontwIm);
