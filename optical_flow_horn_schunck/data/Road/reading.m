I0 = double(imread('0000.pgm'));
for cptImage = 1:199
	if(cptImage < 10)
		nom = sprintf('000%d.pgm',cptImage);
	elseif(cptImage<100)
		nom = sprintf('00%d.pgm',cptImage);
	else
		nom = sprintf('0%d.pgm',cptImage);
	end
	
	nom1 = ['', nom];
	I1 = double(imread(nom1));
	imshow(mat2gray(I1));
	title(nom1);
    % frame difference
    
	I0 = I1;
	pause(0.2);
end

