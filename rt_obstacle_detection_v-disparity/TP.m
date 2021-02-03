%% P2-Q1
Id = double(rgb2gray(imread('01D.png')))/255;
Ig = double(rgb2gray(imread('01G.png')))/255;
Imm_size=size(Id);
c=stereoAnaglyph(Id,Ig);
imshow(c);

%% P2-Q2
dr = [0 96];
d = disparity(Ig,Id,'DisparityRange',dr); 
dbm = disparityBM(Ig,Id,'DisparityRange',dr); 
dsgm = disparitySGM(Ig,Id,'DisparityRange',dr ); 
imshow(d/dr(2)); title("Avec la fonction disparity");
figure;
imshow(dbm/dr(2)); title("Avec la fonction disparityBM");
figure;
imshow(dsgm/dr(2)); title("Avec la fonction disparitySGM");

%% P3-Q1
vdisp = zeros(size(dsgm));

for i=1:size(dsgm,1)
    for k=0:dr(2)
        for j=1:size(dsgm,2)
            if round(dsgm(i,j)+1)==k
                vdisp(i,k) = vdisp(i,k)+1;
            end
        end
    end
end

imshow([dsgm vdisp], dr);

%% P3-Q2
svd = 1;
X=[];
Y=[];
for i = 1:size(vdisp,1)
    for j = 1:size(vdisp,2)
        if vdisp(i,j) > svd
            X=[X;j];
            Y=[Y;i];
        end
    end
end
b = robustfit(X,Y);
x = 0:size(vdisp,1);
y = b(1) + b(2).*x;
imshow(vdisp);
hold on
plot(x,y,'r');

%% P3-Q3
th =15;
I_obst=zeros(dr(2),1);
for max=1:dr(2)
    for j=1:Imm_size(1)
        if vdisp(j,max)>th 
               I_obst(max)=I_obst(max)+1;
            end
        end
end
plot(I_obst); title("Histogramme en disparité");
detect=zeros(size(I_obst));
for max=1 : length (I_obst)
    if I_obst(max)> th
        detect(max)=1;
    end 
end 
max=dr(2);
while detect(max) ~=1
    max=max-1;
end 
Y=b(1)+b(2).*max;
figure;
imshow(Id); title("La ligne jusqu’à laquelle il n’y a pas d’obstacle");
hold on 
plot(0:size(Id,2),Y+0*(0:size(Id,2)),'g');

%% P3-Q4-1
Id = double(rgb2gray(imread('02D.png')))/255;
Ig = double(rgb2gray(imread('02G.png')))/255;
Imm_size=size(Id);

dr = [0 96];
d = disparity(Ig,Id,'DisparityRange',dr); 
dbm = disparityBM(Ig,Id,'DisparityRange',dr); 
dsgm = disparitySGM(Ig,Id,'DisparityRange',dr ); 

vdisp = zeros(size(dsgm));

for i=1:size(dsgm,1)
    for k=0:dr(2)
        for j=1:size(dsgm,2)
            if round(dsgm(i,j)+1)==k
                vdisp(i,k) = vdisp(i,k)+1;
            end
        end
    end
end

imshow([dsgm vdisp], dr);

%% P3-Q4-2
svd = 1;
X=[];
Y=[];
for i = 1:size(vdisp,1)
    for j = 1:size(vdisp,2)
        if vdisp(i,j) > svd
            X=[X;j];
            Y=[Y;i];
        end
    end
end
b = robustfit(X,Y);
x = 0:size(vdisp,1);
y = b(1) + b(2).*x;
imshow(vdisp);
hold on
plot(x,y,'r');

%% P3-Q4-3
th =15;
I_obst=zeros(dr(2),1);
for max=1:dr(2)
    for j=1:Imm_size(1)
        if vdisp(j,max)>th 
               I_obst(max)=I_obst(max)+1;
            end
        end
end
plot(I_obst); title("Histogramme en disparité");
detect=zeros(size(I_obst));
for max=1 : length (I_obst)
    if I_obst(max)> th
        detect(max)=1;
    end 
end 
max=dr(2);
while detect(max) ~=1
    max=max-1;
end 
Y=b(1)+b(2).*max;
figure;
imshow(Id); title("La ligne jusqu’à laquelle il n’y a pas d’obstacle");
hold on 
plot(0:size(Id,2),Y+0*(0:size(Id,2)),'g');

%% P3-Q5-1
Id = double(rgb2gray(imread('03D.png')))/255;
Ig = double(rgb2gray(imread('03G.png')))/255;
Imm_size=size(Id);

dr = [0 96];
d = disparity(Ig,Id,'DisparityRange',dr); 
dbm = disparityBM(Ig,Id,'DisparityRange',dr); 
dsgm = disparitySGM(Ig,Id,'DisparityRange',dr ); 

vdisp = zeros(size(dsgm));

for i=1:size(dsgm,1)
    for k=0:dr(2)
        for j=1:size(dsgm,2)
            if round(dsgm(i,j)+1)==k
                vdisp(i,k) = vdisp(i,k)+1;
            end
        end
    end
end

imshow([dsgm vdisp], dr);

%% P3-Q5-2
svd = 7.5;
X=[];
Y=[];
for i = 1:size(vdisp,1)
    for j = 1:size(vdisp,2)
        if vdisp(i,j) > svd
            X=[X;j];
            Y=[Y;i];
        end
    end
end
b = robustfit(X,Y);
x = 0:size(vdisp,1);
y = b(1) + b(2).*x;
imshow(vdisp);
hold on
plot(x,y,'r');

%% P3-Q5-3
th =15;
 I_obst=zeros(dr(2),1);
for max=1:dr(2)
    for j=1:Imm_size(1)
        if vdisp(j,max)>th 
               I_obst(max)=I_obst(max)+1;
            end
        end
end
plot(I_obst); title("Histogramme en disparité");
detect=zeros(size(I_obst));
for max=1 : length (I_obst)
    if I_obst(max)> th
        detect(max)=1;
    end 
end 
max=dr(2);
while detect(max) ~=1
    max=max-1;
end 
Y=b(1)+b(2).*max;
figure;
imshow(Id); title("La ligne jusqu’à laquelle il n’y a pas d’obstacle");
hold on 
plot(0:size(Id,2),Y+0*(0:size(Id,2)),'g');
