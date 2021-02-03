%% Q3 - estimer l'intensité du ciel Is 
I=double(imread('F00.png'))/255.0;
Is = max(I,[],2);

%% Q4 - calculer le voile
sv=2*floor(max(size(I))/25)+1;
median_I = medfilt2(I, [sv sv], 'symmetric');
%V=zeros(size(I));

V=min(I,median_I)*0.95; % forcer V a etre inférieur à I pour pas avoir des valeurs negatives en I0 et éviter les trous noirs

%% Q5 - Calculer l'image apres restauration

I0=((I-V)./(Is-V)).*Is;

%% Q6 - appliquer une puissance pour éclairssir
gamma=0.6;
I0_eclair = I0.^gamma;
imshow(I0_eclair);
figure;
imshow(I);

%% Q7 - refaire la même chose pour F01
I=double(imread('F01.png'))/255.0;
Is = max(I,[],2);
median_I = medfilt2(I, [sv sv], 'symmetric');
V=min(I,median_I)*0.95;
I0 = (Is.*(I-V))./(Is-V);
I0_eclair = I0.^gamma;
imshow(I0_eclair);
figure;
imshow(I);

%% Q8 - refaire la même chose pour F02
I=double(imread('F02.png'))/255.0;
Is = max(I,[],2);
median_I = medfilt2(I, [sv sv], 'symmetric');
V=min(I,median_I)*0.95;
I0 = (Is.*(I-V))./(Is-V);
I0_eclair = I0.^gamma;
imshow(I0_eclair);
figure;
imshow(I);

%% Q9 - refaire la même chose pour F03 ( adapter pour les couleurs )
% appliquer l'algo pour chaque canal
I = double(imread('F03.png'))/255.0;
Ir = I(:,:,1);
Ig = I(:,:,2);
Ib = I(:,:,3);

Isr = max(Ir,[],2);
median_Ir = medfilt2(Ir, [sv sv], 'symmetric');
Vr=min(Ir,median_Ir)*0.95;
I0r = (Isr.*(Ir-Vr))./(Isr-Vr);
I0r_eclair = I0r.^gamma;
figure;
imshow(I0r_eclair);

Isg = max(Ig,[],2);
median_Ig = medfilt2(Ig, [sv sv], 'symmetric');
Vg=min(Ig,median_Ig)*0.95;
I0g = (Isg.*(Ig-Vg))./(Isg-Vg);
I0g_eclair = I0g.^gamma;
figure;
imshow(I0g_eclair);

Isb = max(Ib,[],2);
median_Ib = medfilt2(Ib, [sv sv], 'symmetric');
Vb=min(Ib,median_Ib)*0.95;
I0b = (Isb.*(Ib-Vb))./(Isb-Vb);
I0b_eclair = I0b.^gamma;
figure;
imshow(I0b_eclair);


voile_rgb = zeros(size(I));
voile_rgb(:,:,1) = Vr;
voile_rgb(:,:,2) = Vg;
voile_rgb(:,:,3) = Vb;
figure;
imshow(voile_rgb);

% restored_I = zeros(size(I));
restored_I(:,:,1) = I0r_eclair;
restored_I(:,:,2) = I0g_eclair;
restored_I(:,:,3) = I0b_eclair;
figure;
imshow(restored_I);
figure;
imshow(I);

%% Q10 - Adapter la restauration en considérant que le brouillard est parfaitement blanc.
% appliquer l'algo pour chaque canal

I = double(imread('F03.png'))/255.0;
Ir = I(:,:,1);
Ig = I(:,:,2);
Ib = I(:,:,3);

Isr = double(ones(size(Ir)));
median_Ir = medfilt2(Ir, [sv sv], 'symmetric');
Vr=min(Ir,median_Ir)*0.95;
I0r = (Isr.*(Ir-Vr))./(Isr-Vr);
I0r_eclair = I0r.^gamma;
figure;
imshow(I0r_eclair);

Isg = double(ones(size(Ig)));
median_Ig = medfilt2(Ig, [sv sv], 'symmetric');
Vg=min(Ig,median_Ig)*0.95;
I0g = (Isg.*(Ig-Vg))./(Isg-Vg);
I0g_eclair = I0g.^gamma;
figure;
imshow(I0g_eclair);

Isb = double(ones(size(Ib)));
median_Ib = medfilt2(Ib, [sv sv], 'symmetric');
Vb=min(Ib,median_Ib)*0.95;
I0b = (Isb.*(Ib-Vb))./(Isb-Vb);
I0b_eclair = I0b.^gamma;
figure;
imshow(I0b_eclair);


voile_rgb = zeros(size(I));
voile_rgb(:,:,1) = Vr;
voile_rgb(:,:,2) = Vg;
voile_rgb(:,:,3) = Vb;
figure;
imshow(voile_rgb);

% restored_I = zeros(size(I));
restored_I(:,:,1) = I0r_eclair;
restored_I(:,:,2) = I0g_eclair;
restored_I(:,:,3) = I0b_eclair;
figure;
imshow(restored_I);