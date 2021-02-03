%% PARTIE 1

%% Question 1

%% Part 1
h=0.05;
x = -2:h:2;
y = -2:h:2;
[X Y] = meshgrid(x);
F = 20 + X.^2 + Y.^2 -10*(cos(2*pi*X)+cos(2*pi*Y));
surf(X,Y,F);

%% Part 2

figure;
h=0.0025;
x = -0.1:h:0.1;
[X, Y] = meshgrid(x);
F = 20 + X.^2 + Y.^2 -10*(cos(2*pi*X)+cos(2*pi*Y));
surf(X,Y,F);

%% Question 2

figure;
% b -
clear all;
% PSO initialisation du paramètre
% =============================================
n=2; % Nombre de variable
M=40; % Nombre de particle
iterationMax=80; % Maximum iteration
testNb=2; % nombre de test
X_max= [0.1,0.1]; % Borne sup
X_min= [-0.1,-0.1]; % Borne inf
c1=2; % facteur d'accélération 1
c2=2; % facteur d'accélération 2
Wmax=0.9; % poids max
Wmin=0.4; % poids mim
Vmax=1;
F=@F; % pointage sur la fonction F.m

for r=1:testNb
% % PSO intialisation
% % =============================================
    for i=1:M
        for j=1:n
            x(i,j)=X_min(j)+rand()*(X_max(j)-X_min(j));
            v(i,j)=rand()*(X_max(j)-X_min(j));
        end
        Fit(i,:)=F(x(i,:));
        Pb(i,:)=x(i,:); % initialization de la position
    end
    
    [gb1,ind1]=sort(Fit); %renvoie les éléments triés de A le long de la dimension dim
    Gb=x(ind1(1,1),:); % initialisation gbest
% % PSO algorithm
% % =============================================
    for t=1:iterationMax
        t=t+1;
        for i=1:M
            % la mise de jour de pbest
            if F(x(i,:))<Fit(i)
                Fit(i)=F(x(i,:));
                Pb(i,:)=x(i,:);
            end
            % la mise de jour de gbest
            if F(Gb)>Fit(i)
                Gb=Pb(i,:);
            end
            % la mise de jour de velocity
            % calcule de poids de la fonction
            w=Wmax-(Wmax-Wmin)*t/iterationMax;
            v(i,:)=w*v(i,:)+c1*rand*(Pb(i,:)-x(i,:))+c2*rand*(Gb- x(i,:));
            % vérification de velocity
            for j=1:n
                if v(i,j)>Vmax
                    v(i,j)=Vmax;
                elseif v(i,j)<-Vmax
                    v(i,j)=-Vmax;
                end
            end
            % la mise à jour de position
            x(i,:)=x(i,:)+v(i,:);
        end
        Y=F(Gb);
        % afficahge de
        figure(1);
        plot(t,Y,'r.');
        xlabel('Iteration');
        ylabel('Fitness');
        title(sprintf(': %.15f',Y));
        grid on;
        hold on;
        end
        % affichage des résultat
        figure(2);
        PlotFunction()
        hold on;
        scatter3(Gb(1),Gb(2),Y,'fill','ro');
        hold off;
end
