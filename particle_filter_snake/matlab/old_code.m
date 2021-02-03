% close all;
% clear all;
img_0= double(imread('../images/snake_color/snake_0000.png'));
np=200;  % Nombre de particules
for i = 1:np % Pour chaque particule, on initialise ses paramètre
   % initialisation des coordonnées
   p(1,i)=randi(200);
   p(2,i)=randi(200);
   p(3,i)=1;
   
   % initialisation de la coleur en bleu
   img_0(p(1,i),p(2,i),1)=0;
   img_0(p(1,i),p(2,i),2)=0;
   img_0(p(1,i),p(2,i),3)=255;
end

k=0;

for cptImage = 1:1000
    
% Traiter les noms de fichiers des images à lire
if(cptImage<10)
    nom = sprintf('../images/snake_color/snake_000%d.png',cptImage);
elseif(cptImage<100)
    nom = sprintf('../images/snake_color/snake_00%d.png',cptImage);
else
    nom = sprintf('../images/snake_color/snake_0%d.png',cptImage);
end
   
nom1=['',nom];
img_t=double(imread(nom1));

if(k==1)    
   for i = 1:np
        p(1,i)=randi(200);
        p(2,i)=randi(200);
        p(3,i)=1;
   end
   k=0;
end
 

% Particule en x
% Creation du tableau de valeur pour la particule
  
    % Boucle de prediction pour la position de la particule
    for i=1:np
        a=1;
        b=4;
        r = round(a + (b-a).*rand);
        if(p(1,i)>=2 && p(1,i)<=(np-2) && p(2,i)>=2 && p(2,i)<=(np-2))
            if(r==1)
                p(1,i)= p(1,i)+1;
            end 
            if(r==2)
                p(2,i)=p(2,i)+1;
            end 
            if(r==3)
                p(1,i)=p(1,i)-1;
            end
            if(r==4)
                p(2,i)=p(2,i)-1;
            end 
        end
    end
    
    for i=1:np
        if img_t(p(1,i), p(2,i),1)==255
            p(3,i)=1;
        else
            p(3,i)=0;
        end 
    end
    
 if(p(3,:)==0)
        k=1;
 end

for i=1:np
    if(p(3,i)==1)
        for j=1:np
            if(p(3,j)==0)
                p(1,j)=p(1,i);
                p(2,j)=p(2,i);
                p(3,j)=p(3,i);
                break
            end 
        end
    end 
    img_t(p(1,i),p(2,i),1)=0;
    img_t(p(1,i),p(2,i),2)=0;
    img_t(p(1,i),p(2,i),3)=255;
end

subplot(1,1,1);
title("test");
imshow(img_t);

end 

