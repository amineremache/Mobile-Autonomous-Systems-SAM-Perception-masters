

%%%%%%%%%%%%%%%%%%%% TP 3 : FUSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% classification par fusion d'image en fonction de croyance

% I - CLASSIFICATION 2 CLASSES a partir de sources bruitées

% clear; clc; 
% close all

addpath(genpath('Fonctions'));

%% Charger les images sources
% A COMMENTER après une première compilation pour voir les evolutions de l'algorithme sur les mêmes sources. 
Load_images     

%% AJOUT : Exemple de classification très simple 
% Produit des sources puis seuillage à 0.5. 

I_prod = I1.*I2;
Dec_logi = I_prod>0.5;

figure,
subplot(1,3,1),imshow(I1>0.5), title('Classification Seuil Source 1');
subplot(1,3,2),imshow(I2>0.5), title('Classification Seuil Source 2');
subplot(1,3,3), imshow(Dec_logi), title('Classification Produit Seuil'); 

%% Qu 1. Creation des "images de bbas" 
% m1 bba source 1, m2 bba source 2 

m1 = zeros(class_size(1),class_size(1),4);  % ( A, B , AuB, emptyset)
m2 = zeros(class_size(1),class_size(1),4);

%%%%%%%%%%%%% a completer 

% Image de la source 1
m1(:,:,1) = I1; %%
m1(:,:,2) = 1-m1(:,:,1); %%

% Image de la source 2
m2(:,:,1) = I2; %%
m2(:,:,2) = 1-m2(:,:,1); %%

% AuB
m1(:,:,3) = 1-(m1(:,:,1)+m1(:,:,2));
m2(:,:,3) = 1-(m2(:,:,1)+m2(:,:,2));

% empty
m1(:,:,4) = 1-(m1(:,:,1)+m1(:,:,2)+m1(:,:,3));
m2(:,:,4) = 1-(m2(:,:,1)+m2(:,:,2)+m2(:,:,3));

% Afficher la masse de B 
figure; 

subplot(2,2,1)  % Source 1
imshow(m1(:,:,1));
title('m_1(A)','fontsize',fontsIm,'fontweight',fontwIm);

subplot(2,2,2)  % Source 2
imshow(m2(:,:,1));
title('m_2(A)','fontsize',fontsIm,'fontweight',fontwIm);

subplot(2,2,3)  % Source 1
imshow(m1(:,:,2));
title('m_1(B)','fontsize',fontsIm,'fontweight',fontwIm);

subplot(2,2,4)  % Source 2
imshow(m2(:,:,2));
title('m_2(B)','fontsize',fontsIm,'fontweight',fontwIm);

% subplot(4,2,5)  % Source 1
% imshow(m1(:,:,3));
% title('m_1(AuB)','fontsize',fontsIm,'fontweight',fontwIm);
% 
% subplot(4,2,6)  % Source 2
% imshow(m2(:,:,3));
% title('m_2(AuB)','fontsize',fontsIm,'fontweight',fontwIm);
% 
% subplot(4,2,7)  % Source 1
% imshow(m1(:,:,4));
% title('m_1(empty)','fontsize',fontsIm,'fontweight',fontwIm);
% 
% subplot(4,2,8)  % Source 2
% imshow(m2(:,:,4));
% title('m_2(empty)','fontsize',fontsIm,'fontweight',fontwIm);

%% Qu. 2  Appliquer une erosion sur l'image

nbr_er=1; % Nombre de fois erosion
% d_er=3; % Taille de l'element structurant   %% A FAIRE VARIER
% SE=strel('square',d_er);

figure;
cpt = 0;
er_vals = [3 5 7];
for d_er=er_vals

    % Erosion sur l'image
    SE=strel('square',d_er);
%     m1_erd = erosion_Im(m1,d_er,nbr_er);   % completez dans la fonction (ou alors utiliser avec fonction imerode, imopen, et strel pour l'element structurant) 
%     m2_erd = erosion_Im(m2,d_er,nbr_er);
    
    m1_erd = imerode(m1,SE);
    m2_erd = imerode(m2,SE);
    
    % Affichage des resultats
    subplot(length(er_vals),4,1+4*cpt)  % Source 1 - Masse sur A
    imshow(m1_erd(:,:,1)); title('m_1(A) apres erosion');
    subplot(length(er_vals),4,2+4*cpt)  % Source 1 - Masse sur B
    imshow(m1_erd(:,:,2)); title('m_1(B) apres erosion');
    subplot(length(er_vals),4,3+4*cpt)  % Source 2 - Masse sur A
    imshow(m2_erd(:,:,1)); title('m_2(A) apres erosion');
    subplot(length(er_vals),4,4+4*cpt)  % Source 2 - Masse sur B
    imshow(m2_erd(:,:,2)); title('m_2(B) apres erosion');
    cpt = cpt +1;
end

%% Qu 3.  Calcul de l'ignorance = m(Omega) = m(AuB)

% Calcul de l'ignorance (a completer)                       
m1_erd(:,:,3) = 1-(m1_erd(:,:,1)+m1_erd(:,:,2));%%
m2_erd(:,:,3) = 1-(m2_erd(:,:,1)+m2_erd(:,:,2));%%

% Affichage de m(Omega)
figure, 
subplot(1,2,1), imshow(m1_erd(:,:,3)); title('Ignorance Source 1');
subplot(1,2,2), imshow(m2_erd(:,:,3)); title('Ignorance Source 2');

%% Qu 4. Combinaison conjonctive des bbas
% Rappel Def :  m12(A) = somme ( m1(B) * m2(C) )  pour tout BnC = A

% m12_erd = zeros(size(m1));

% Version 1 : EN DUR

% % Classe A
% m12_erd(:,:,1) = m1_erd(:,:,1).*m2_erd(:,:,1) + m1_erd(:,:,3).*m2_erd(:,:,1) + m2_erd(:,:,3).*m1_erd(:,:,1);
% % Classe B 
% m12_erd(:,:,2) = m1_erd(:,:,2).*m2_erd(:,:,2) + m1_erd(:,:,3).*m2_erd(:,:,2) + m2_erd(:,:,3).*m1_erd(:,:,2);%%
% % Classe AuB 
% m12_erd(:,:,3) = m1_erd(:,:,3).*m2_erd(:,:,3);%%
% % Classe ensemble vide
% m12_erd(:,:,4) = m1_erd(:,:,1).*m2_erd(:,:,2) + m1_erd(:,:,2).*m2_erd(:,:,1);%%

% Version 2 :Cas général 

m12_erd = Regle_Dempster(m1_erd,m2_erd);   %% Completer la fonction 


%% Qu 5. Calcul des BetP et affichage du resultat de classification

Dec_erd = Decision(m12_erd); %% Completer la fonction

figure;
imshow(Dec_erd,[]),
title({'Resultat de classification avec erosion' ['d = ' num2str(d_er)]});


%% Qu 6.  Calcul de l'ouverture 

% Ouverture à partir de l'érodé 

nbr_er=1; % Nombre de fois erosion
% d_er=3; % Taille de l'element structurant   %% A FAIRE VARIER
% SE=strel('square',d_er);

figure;

cpt = 0;
er_vals = [3 5 7];

for d_er=er_vals

    % Erosion sur l'image
    SE=strel('square',d_er);
%     m1_op = dilatation_Im(m1_erd,d_er,nbr_er);   % completez dans la fonction (ou alors utiliser avec fonction imerode, imopen, et strel pour l'element structurant) 
%     m2_op = dilatation_Im(m2_erd,d_er,nbr_er);
    
    m1_erd = imdilate(m1_erd,SE);
    m2_erd = imdilate(m2_erd,SE);
    
    % Affichage des resultats
    subplot(length(er_vals),4,1+4*cpt)  % Source 1 - Masse sur A
    imshow(m1_op(:,:,1)); title('m1\_erd(A) apres ouverture');
    subplot(length(er_vals),4,2+4*cpt)  % Source 1 - Masse sur B
    imshow(m1_op(:,:,2)); title('m1\_erd(B) apres ouverture');
    subplot(length(er_vals),4,3+4*cpt)  % Source 2 - Masse sur A
    imshow(m2_op(:,:,1)); title('m2\_erd(A) apres ouverture');
    subplot(length(er_vals),4,4+4*cpt)  % Source 2 - Masse sur B
    imshow(m2_op(:,:,2)); title('m2\_erd(B) apres ouverture');
    cpt = cpt +1;
end

%% Qu 7. Reprendre les questions 3 à 5 à partir de m1_op et m2_op 

% Calcul de l'ignorance (a completer)                       
m1_op(:,:,3) = 1-(m1_op(:,:,1)+m1_op(:,:,2));%%
m2_op(:,:,3) = 1-(m2_op(:,:,1)+m2_op(:,:,2));%%

% Affichage de m(Omega)
figure, 
subplot(1,2,1), imshow(m1_op(:,:,3)); title('Ouverture - Ignorance Source 1');
subplot(1,2,2), imshow(m2_op(:,:,3)); title('Ouverture - Ignorance Source 2');
    

%% Calcul de la combinaison conjonctive
% m12_op = zeros(size(m1));
% 
% % Version 1 :  EN DUR 
% % Classe A
% m12_op(:,:,1) = m1_op(:,:,1).*m2_op(:,:,1) + m1_op(:,:,3).*m2_op(:,:,1) + m2_op(:,:,3).*m1_op(:,:,1);%% A completer (/!\ au pixel à pixel)
% % Classe B 
% m12_op(:,:,2) = m1_op(:,:,2).*m2_op(:,:,2) + m1_op(:,:,3).*m2_op(:,:,2) + m2_op(:,:,3).*m1_op(:,:,2);%%
% % Classe AuB 
% m12_op(:,:,3) = m1_op(:,:,3).*m2_op(:,:,3);%%

% Version 2 :  cas général 

m12_op = Regle_Dempster(m1_op,m2_op); % Completer la fonction

%% BetP et Decision

Dec_op = Decision(m12_op); %% Completer la fonction

figure;
imshow(Dec_op,[]),
title({'Resultat de classification avec ouverture' ['d = ' num2str(d_er)]});


%% Qu 8 Affichage des résultats comparaison 

figure, 

subplot(1,3,1), imshow(Dec_logi,[]); title( 'Decision Produit Seuil');
subplot(1,3,2), imshow(Dec_erd,[]) ; title({'Decision avec Erosion' ['d = ' num2str(d_er)]});
subplot(1,3,3), imshow(Dec_op,[])  ; title({'Decision avec Ouverture' ['d = ' num2str(d_er)]}); 