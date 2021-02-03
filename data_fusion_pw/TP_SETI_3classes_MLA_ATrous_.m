

%%%%%%%%%%%%%%%%%%%% TP 3 : FUSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% classification par fusion d'image en fonction de croyance

% II - CLASSIFICATION 3 CLASSES a partir de sources bruitées

% clear; clc; 
% close all

addpath(genpath('Fonctions'));

%% Chargement et affichage des images

Im1 = double(imread('ima_dat1.png'))/255;
Im2 = double(imread('ima_dat2.png'))/255;

subplot(1,2,1)
imshow(Im1); title('m_1(C2)');
subplot(1,2,2)
imshow(Im2); title('m_2(C1uC2)');

%% Qu.1  Allocation des masses sur les 3 classes

S1 = zeros(size(Im1,1),size(Im1,2),8);
S2 = zeros(size(Im2,1),size(Im2,2),8);

% image 1 a  deux classes : C2 (010) et C1 U C3 (101)
indice_C2    = bin2dec('010');  
indice_C1uC3 = bin2dec('101');

S1(:,:,indice_C2)    = Im1;
S1(:,:,indice_C1uC3) = 1-S1(:,:,indice_C2);

% image 2 a  deux classes : C3 (100) et C1 U C2 (011)
indice_C3    = bin2dec('100');  
indice_C1uC2 = bin2dec('011');

S2(:,:,indice_C1uC2) = Im2;
S2(:,:,indice_C3) = 1-S2(:,:,indice_C1uC2);

% Affichage des 4 elements focaux : C2, C3, C1uC3, C1uC2 
figure, 
subplot(2,2,1), imshow( S1(:,:,indice_C2) ), title('C2'); 
subplot(2,2,2), imshow( S2(:,:,indice_C3) ), title('C3'); 
subplot(2,2,3), imshow( S1(:,:,indice_C1uC3) ), title('C1 u C3'); 
subplot(2,2,4), imshow( S2(:,:,indice_C1uC2) ), title('C1 u C2'); 

%% Qu.2  Coder la règle conjonctive pour plus de 2 classes

S12 = Regle_Dempster(S1,S2);  % completer Regle_Dempster

%% Qu.3  Reprendre les questions qu2 à qu6 

%% EROSION - Appliquer une erosion sur l'image

nbr_er=1; % Nombre de fois erosion
%d_er=2; % Taille de l'element structurant   %% A FAIRE VARIER

figure;
cpt = 0;
er_vals = [7];

for d_er=er_vals

%     % Erosion sur l'image
%     SE=strel('square',d_er);
%     m1_erd = imerode(m1,SE);
%     m2_erd = imerode(m2,SE);
    
    % Erosion sur l'image
    S1_erd = erosion_Im(S1,d_er,nbr_er);   % completez dans la fonction (ou alors utiliser avec fonction imerode, imopen, et strel pour l'element structurant) 
    S2_erd = erosion_Im(S2,d_er,nbr_er);
    
    % Affichage des 4 elements focaux : C2, C3, C1uC3, C1uC2 
    subplot(length(er_vals),4,1+4*cpt), imshow( S1_erd(:,:,indice_C2) ), title({'C2' 'apres erosion'}); 
    subplot(length(er_vals),4,2+4*cpt), imshow( S2_erd(:,:,indice_C3) ), title({'C3' 'apres erosion'}); 
    subplot(length(er_vals),4,3+4*cpt), imshow( S1_erd(:,:,indice_C1uC3) ), title({'C1 u C3' 'apres erosion'}); 
    subplot(length(er_vals),4,4+4*cpt), imshow( S2_erd(:,:,indice_C1uC2) ), title({'C1 u C2' 'apres erosion'}); 
    cpt = cpt +1;
end

%% EROSION - Calcul de l'ignorance = m(Omega) = m(AuB)

% Calcul de l'ignorance (a completer)   
indice_C1uC2uC3 = bin2dec('111'); % indice_Omega

S1_erd(:,:,indice_C1uC2uC3) = 1-(S1_erd(:,:,indice_C2)+S1_erd(:,:,indice_C1uC3));
S2_erd(:,:,indice_C1uC2uC3) = 1-(S2_erd(:,:,indice_C1uC2)+S2_erd(:,:,indice_C3));

% Affichage de S(Omega)
figure, 
subplot(1,2,1), imshow(S1_erd(:,:,indice_C1uC2uC3)); title('Ignorance Source 1');
subplot(1,2,2), imshow(S2_erd(:,:,indice_C1uC2uC3)); title(' Ignorance Source 2');

%% EROSION -  Combinaison conjonctive des bbas

S12_erd = Regle_Dempster(S1_erd,S2_erd);

%% EROSION -  Calcul des BetP et décision 
 
Dec_erd = Decision(S12_erd); %% Completer la fonction

figure, imshow(Dec_erd,[]), title ({'Decision avec Erosion' ['d = ' num2str(d_er)]});


%% OUVERTURE - Appliquer une ouverture sur l'image

% Erosion sur l'image
S1_op = dilatation_Im(S1_erd,d_er,nbr_er);   % completez dans la fonction (ou alors utiliser avec fonction imerode, imopen, et strel pour l'element structurant) 
S2_op = dilatation_Im(S2_erd,d_er,nbr_er);

% Affichage des 4 elements focaux : C2, C3, C1uC3, C1uC2 
figure, 
subplot(2,2,1), imshow( S1_op(:,:,indice_C2) ), title({'C2' 'apres ouverture'}); 
subplot(2,2,2), imshow( S2_op(:,:,indice_C3) ), title({'C3' 'apres ouverture'}); 
subplot(2,2,3), imshow( S1_op(:,:,indice_C1uC3) ), title({'C1 u C3' 'apres ouverture'}); 
subplot(2,2,4), imshow( S2_op(:,:,indice_C1uC2) ), title({'C1 u C2' 'apres ouverture'}); 

%% EROSION - Calcul de l'ignorance = m(Omega) = m(AuB)

% Calcul de l'ignorance (a completer)   
indice_C1uC2uC3 = bin2dec('111'); % indice_Omega

S1_op(:,:,indice_C1uC2uC3) = 1-(S2_erd(:,:,indice_C2)+S2_erd(:,:,indice_C1uC3));
S2_io(:,:,indice_C1uC2uC3) = 1-(S2_erd(:,:,indice_C1uC2)+S2_erd(:,:,indice_C3));

% Affichage de S(Omega)
figure, 
subplot(1,2,1), imshow(S1_op(:,:,indice_C1uC2uC3)); title(' Ignorance Source 1');
subplot(1,2,2), imshow(S2_op(:,:,indice_C1uC2uC3)); title(' Ignorance Source 2');

%% EROSION -  Combinaison conjonctive des bbas

S12_op = Regle_Dempster(S1_op,S2_op);

%% EROSION -  Calcul des BetP et décision 

Dec_op = Decision(S12_op); %% Completer la fonction

figure, imshow(Dec_op,[]), title ({'Decision avec Erosion' ['d = ' num2str(d_er)]});

%% COMPARAISON 
%close all,
figure, 
subplot(1,2,1), imshow(Dec_erd,[]), title ({'Decision avec Erosion' ['d = ' num2str(d_er)]});
subplot(1,2,2), imshow(Dec_op,[]), title ({'Decision avec Ouverture' ['d = ' num2str(d_er)]});