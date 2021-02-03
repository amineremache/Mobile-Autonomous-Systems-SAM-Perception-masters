addpath(genpath('Fonctions'));

Im1 = double(imread('ima_dat1.png'))/255;
Im2 = double(imread('ima_dat2.png'))/255;

S1 = zeros(size(Im1,1),size(Im1,2),8);
S2 = zeros(size(Im2,1),size(Im2,2),8);

indice_C2    = bin2dec('010');  
indice_C1uC3 = bin2dec('101');

S1(:,:,indice_C2)    = Im1;
S1(:,:,indice_C1uC3) = 1-S1(:,:,indice_C2);

indice_C3    = bin2dec('100');  
indice_C1uC2 = bin2dec('011');

S2(:,:,indice_C1uC2) = Im2;
S2(:,:,indice_C3) = 1-S2(:,:,indice_C1uC2);

d=3;
[Imlab,M_neig] = Reg_BBA(S1,d);