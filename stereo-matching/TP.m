%% Question 1 - Lire les 2 images
Im_1 = double(rgb2gray(imread('venus1.ppm')))/255;
Im_2 = double(rgb2gray(imread('venus2.ppm')))/255;
subplot(1,2,1);
imshow(Im_1);
title("Image gauche");
subplot(1,2,2);
imshow(Im_2);
title("Image droite");

%% Question 2 - Configuration des caméras
figure;
imshow(stereoAnaglyph(Im_2,Im_1));
title("Résultat de stereoAnaglyph");

%% Question 3 - profil d’une ligne
l=50;
ligne_1 = Im_1(l,:);
ligne_2 = Im_2(l,:);

subplot(1,2,1); 
plot([1:size(Im_1,2)],ligne_1*255);
title("Profil de ligne Image 1");
subplot(1,2,2); 
plot([1:size(Im_2,2)],ligne_2*255);
title("Profil de ligne Image 2");

%% Question 4 - estimer visuellement la disparité

imtool(Im_1);
imtool(Im_2);

%% Question 5 
blocSize = 5;
dispMax = 5;
seuilContraste = 0.6;
simfunc = "SAD"; % SAD, SSD, NCC
D= blockMatching(Im_1,Im_2,blocSize, dispMax, seuilContraste,simfunc);

% =========================================
%        Visualize Disparity Map
% =========================================

% Display the disparity map. 
% Passing an empty matrix as the second argument tells imshow to take the
% minimum and maximum values of the data and map the data range to the 
% display colors.
figure;
imshow(D, []);

% Configure the axes to properly display an image.
axis image;

% Use the 'jet' color map.
% You might also consider removing this line to view the disparity map in
% grayscale.
colormap('jet');

% Display the color map legend.
colorbar;

% Set the title to display.
title(strcat('Block matching, Block size = ', num2str(blockSize)));

%% Question 6 - l’influence des differents parametres
blocSizes = [3 5 7];
dispMaxes = [2 3 5 10];
i=1;
for blocSize=blocSizes
    for dispMax=dispMaxes
        D= blockMatching(Im_1,Im_2,blocSize, dispMax, seuilContraste,simfunc);
        subplot(length(blocSizes),length(dispMaxes),i);
        imshow(D, []);
        axis image;
        colormap('jet');
        colorbar;
        title(strcat('Block matching, blocSize= ', num2str(blocSize), ', dispMax= ',num2str(dispMax)));
        i=i+1;
    end
end

%% Question 7 - L’influence des fonctions de similarité
blocSize = 5;
dispMax = 5;
simfuncs = ["SAD", "SSD", "NCC"];
for i=1:length(simfuncs)
    D= blockMatching(Im_1,Im_2,blocSize, dispMax, seuilContraste,simfuncs(i));
    subplot(1,length(simfuncs),i);
    imshow(D, []);
    axis image;
    colormap('jet');
    colorbar;
    title(strcat('Similarity function= ',simfuncs(i), ' blocSize= ', num2str(blockSize), ', dispMax= ',num2str(dispMax)));
    i=i+1;
end