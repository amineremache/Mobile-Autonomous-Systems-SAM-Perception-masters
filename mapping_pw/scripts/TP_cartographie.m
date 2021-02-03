%% Question 1

edges = load('./data/edge.dat');
vertex = load('./data/vertex.dat');

% matrice_adjacence = zeros(size(vertex));
% for i = 1:size(edges)
%    matrice_adjacence(edges(i,2),edges(i,3)) = edges(i,3);
%    matrice_adjacence(edges(i,3),edges(i,2)) = edges(i,3);
% end

%G=graph(matrice_adjacence,string(vertex(:,1)));
%plot(G,'NodeLabel',G.Nodes.Name);

%%%% The problem with the first method is that the graph was built from the
%%%% adjacency matrix, wich is independent from the (X,Y)s of our iterations

for i = 1:size(edges)
   starts = [vertex(edges(i,2),2) vertex(edges(i,3),2)];
   ends = [vertex(edges(i,2),3) vertex(edges(i,3),3)];
   plot(starts,ends,'k')
   hold on
end
text(vertex(:,2),vertex(:,3),string(vertex(:,1)) ,'FontSize',12);

%% Question 2

gps = load('./data/gps.dat');

%hold off
%plot(gps(:,1),gps(:,2),'r');

% Si on essaye de traçer sur la même figure, on a un problème d'affichage
% car on n'a pas le même ordre de grandeur puisque ce sont des données 
% de deux systèmes différents

%figure;
%plot(gps(:,1),gps(:,2),'r');

% Explication : On ne peut pas représenter les deux graphes dans le même
% plot, car on n'est pas dans le même système référentiel.



%% Question 3

% Le référentiel géographique est l’ensemble de "conventions" qui permettent
% d’associer à tout iteration d’une partie de la surface terrestre un iteration
% "unique" sur une carte, et il est donc absolue slon la définition, 
% car il est y a un seul repère pour tout le globe terrestre.
% Donc si chacun s'amuse à utiliser son propre système de coordonnées, 
% sans avoir un terrain standard ou commun, ,on ne pourra plus
% communiquer, c'est pour cela qu'il est plus judicieux de faire le
% recalage dans ce sens.


%% Question 4

% On peut définir le nombre minimum de iteration empriiquement
% pour p=1, on a 4 paramètres à déterminer : a0,a1,b0,b1
% et donc 1 seul iteration de liaison pourrait suffir puisque on aura 4
% équations pour X1, Y1, X1' et Y1'
% pour p=2, on a 6 paramètres à déterminier : a0,a1,a2,b0,b1,b2
% et donc on aura besoin de 2 iterations de liaison minimum qui donneront
% 8 équiations : X1, Y1, X1', Y1', X2, Y2, X2' et Y2'
% pour p=3, 8 paramètres donc minimum 2 iterations
% pour p=4, 10 paramètres min = 3 iterations ( 12 équiations )
% pour p=5, 12 paramètres min = 3 iterations ( 12 )
% pour p=6, 14 paramètres  min = 4 iterations ( 16 )

% Formule générale : nombre minimum = [p/2] ( partie entière de p/2 )


%% Question 5

% Il s'agit de coordonnées géographiques 

%% Question 6

original_links = load('./data/links.dat');

%% Question 7

vertex(:,2)=vertex(:,2)/max(vertex(:,2)); % coordonnées X normalisées 
vertex(:,3)=vertex(:,3)/max(vertex(:,3)); % coordonnées Y normalisées

best_rmse = 0;
for sample_size=20:20
for iteration=1:1
%links(iteration,:) = [];
%test = reshape([35 479 87 123 275 21 449 13 51 163 129 211 184 241 357 70 77 234 17 410],20,1);
%links = original_links(test,:);

links = original_links(randsample(length(original_links),sample_size),:);

%% Question 8

%X = [a0,a1,a2,a3,b0,b1,b2,b3]';
p=3;
m=length(links);

Ax=ones(m,(p+1));
for i=1:m
    Ax(i,2)=vertex(links(i,1),2); % chercher les coordonnées X des iterations de liaison dans la vertex
end
Ax(:,3)=Ax(:,2).^(p-1);
Ax(:,4)=Ax(:,2).^p;

Ay=ones(m,(p+1));
for i=1:m
    Ay(i,2)=vertex(links(i,1),3); % chercher les coordonnées Y des iterations de liaison dans la vertex
end
Ay(:,3)=Ay(:,2).^(p-1);
Ay(:,4)=Ay(:,2).^p;

Bx=links(:,2); % Les coordonnées X "ground truth"
By=links(:,3); % Les coordonnées Y "ground truth"


% Pour tester les resultats si on utilise une seule matrice A et B
A=zeros(m,2*(p+1));
A(1:m,1:4)=Ax;
A(1:m,5:8)=Ay; 
B=zeros(m,2);
B(:,1)=Bx;
B(:,2)=By;

%% Question 9

%Xx=inv(Ax'*Ax)*Ax'*Bx; % estimation des paramètres a0,a1,a2,a3
%Xy=inv(Ay'*Ay)*Ay'*By; % estimation des paramètres b0,b1,b2,b3

Xx=Ax\Bx; % estimation des paramètres a0,a1,a2,a3
Xy=Ay\By; % estimation des paramètres b0,b1,b2,b3

%X = inv(A'*A)*A'*B;
X=A\B; % Pour tester les resultats si on utilise une seule matrice X


% utiliser les paramètres éstimés pour créer la matrice Ax
newAx = ones(length(vertex),p+1);
newAx(:,2) = vertex(:,2);
newAx(:,3) = newAx(:,2).^(p-1);
newAx(:,4) = newAx(:,2).^(p);

% utiliser les paramètres éstimés pour créer la matrice Ay
newAy = ones(length(vertex),p+1);
newAy(:,2) = vertex(:,3);
newAy(:,3) = newAy(:,2).^(p-1);
newAy(:,4) = newAy(:,2).^(p);

% Pour tester les resultats si on utilise une seule matrice newA
newA = zeros(length(vertex),2*(p+1));
newA(1:length(vertex),1:4)=newAx;
newA(1:length(vertex),5:8)=newAy;

% Calcul des nouvelles coordonnées estimées 
newB2 = zeros(size(vertex));
newB2(:,1) = vertex(:,1);
newB2(:,2) = newAx*Xx; % les coordonnées X_chapeau calculées à partir des paramètres estimés
newB2(:,3) = newAy*Xy; % les coordonnées Y_chapeau calculées à partir des paramètres estimés


% Pour tester les resultats si on utilise une seule matrice newB
newB = zeros(size(vertex));
newB(:,1) = vertex(:,1);
newB(:,2:3)= newA*X;

figure;

for i = 1:size(edges)
   starts = [newB(edges(i,2),2) newB(edges(i,3),2)];
   ends = [newB(edges(i,2),3) newB(edges(i,3),3)];
   plot(starts,ends,'k')
   hold on
end

text(newB(:,2),newB(:,3),string(newB(:,1)) ,'FontSize',8);
plot(gps(:,1),gps(:,2),'r','linewidth',2);
f=gcf;

fname = strcat('results/temp',num2str(sample_size),'_iteration_',num2str(iteration),'.png');
exportgraphics(f,fname,'Resolution',300);
close;

% RMSE 2D

e = links(:,2:3)-newB(links(:,1),2:3);
sqe = e.^2;
mse = mean(sqe(:));
rmse = sqrt(mse);

if iteration==1
    best_rmse = rmse;
elseif rmse <= best_rmse
    best_rmse = rmse;
end

fid = fopen('results/temp.log', 'a');
if fid == -1
  error('Cannot open log file.');
end
fprintf(fid, '\n%s: sample size = %d | iteration = %d | selected points:\n', datestr(now, 0), sample_size,iteration);
fprintf(fid, '%d ', links(:,1));
fprintf(fid, '\nRMSE_2D: %f m\n',rmse);
fclose(fid);

fprintf('\n%s: sample size = %d | iteration = %d | selected points:\n', datestr(now, 0), sample_size,iteration);
fprintf('%d ', links(:,1));
fprintf('\nRMSE_2D: %f m\n',rmse);

end
end

fprintf('\nBest RMSE %f\n',best_rmse); % Si on veux chercher quelle combinaison de points voir le fichier log.

%% Question 10 - J'utilise une 5-fold cross validation avec une population de taille 168, qui est divisible par 6.

m = length(original_links);
indices = [1:m/6:5*m/6];

for train_indice=indices
    test_set = original_links(train_indice:train_indice+(m/6)-1,:);
    train_set = setdiff(original_links,test_set,'rows');
  
    p=3;
    m=length(train_set);

    Ax=ones(m,(p+1));
    for i=1:m
        Ax(i,2)=vertex(train_set(i,1),2); 
    end
    Ax(:,3)=Ax(:,2).^(p-1);
    Ax(:,4)=Ax(:,2).^p;

    Ay=ones(m,(p+1));
    for i=1:m
        Ay(i,2)=vertex(train_set(i,1),3);
    end
    Ay(:,3)=Ay(:,2).^(p-1);
    Ay(:,4)=Ay(:,2).^p;

    Bx=train_set(:,2); 
    By=train_set(:,3);

    A=zeros(m,2*(p+1));
    A(1:m,1:4)=Ax;
    A(1:m,5:8)=Ay; 
    B=zeros(m,2);
    B(:,1)=Bx;
    B(:,2)=By;

    %Xx=Ax\Bx;
    %Xy=Ay\By;
    X=A\B;
    
    % utiliser les paramètres éstimés pour créer la matrice Ax
    newAx = ones(length(test_set),p+1);
    
    for i=1:length(test_set)
        newAx(i,2)=vertex(test_set(i,1),2);
    end
    
    newAx(:,3) = newAx(:,2).^(p-1);
    newAx(:,4) = newAx(:,2).^(p);

    % utiliser les paramètres éstimés pour créer la matrice Ay
    newAy = ones(length(test_set),p+1);
    
    for i=1:length(test_set)
        newAy(i,2)=vertex(test_set(i,1),3);
    end
    
    newAy(:,3) = newAy(:,2).^(p-1);
    newAy(:,4) = newAy(:,2).^(p);

    % Pour tester les resultats si on utilise une seule matrice newA
    newA = zeros(length(test_set),2*(p+1));
    newA(1:length(test_set),1:4)=newAx;
    newA(1:length(test_set),5:8)=newAy;

    % Calcul des nouvelles coordonnées estimées 
    newB2 = zeros(size(test_set));
    newB2(:,1) = test_set(:,1);
    newB2(:,2) = newAx*Xx; % les coordonnées X_chapeau calculées à partir des paramètres estimés
    newB2(:,3) = newAy*Xy; % les coordonnées Y_chapeau calculées à partir des paramètres estimés


    % Pour tester les resultats si on utilise une seule matrice newB
    newB = zeros(size(test_set));
    newB(:,1) = test_set(:,1);
    newB(:,2:3)= newA*X;

    e = test_set(:,2:3)-newB(:,2:3);
    sqe = e.^2;
    mse = mean(sqe(:));
    rmse = sqrt(mse);

    fid = fopen('results/temp.log', 'a');
    if fid == -1
      error('Cannot open log file.');
    end
    fprintf(fid, '\n%s: fold = %d | test points:\n', datestr(now, 0), ((train_indice-1)*6/length(original_links))+1);
    fprintf(fid, '%d ', test_set(:,1));
    fprintf(fid, '\nRMSE fold %d: %f m\n',((train_indice-1)*6/length(original_links))+1,rmse);
    fclose(fid);

    fprintf('\n%s: fold = %d | test points:\n', datestr(now, 0), ((train_indice-1)*6/length(original_links))+1);
    fprintf('%d ', test_set(:,1));
    fprintf('\nRMSE fold %d: %f m\n',((train_indice-1)*6/length(original_links))+1,rmse);

end
