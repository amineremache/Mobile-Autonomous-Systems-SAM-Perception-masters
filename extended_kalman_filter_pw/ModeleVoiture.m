 function  [VehiculeRoues,VehiculeCaisse,VehiculeVitres] =  ModeleVoiture(AngleVehiculeIMM,PosVehicule,VehiculeRoues,VehiculeCaisse,VehiculeVitres); 
  
% le contour de notre véhicule
%===============================
						%	P1		 P4
Pos1=[-1.9 1];          %   ________
Pos2=[-2 .9]; 			%	|	   |
Pos3=[-2 -.9]; 		    %	|      |
Pos4=[-1.9 -1]; 		%	 -------

Pos5=[2.2 -1];			% P2		  P3
Pos6=[2.3 -.9];
Pos7=[2.3 .9];
Pos8=[2.2 1];

MatRot=[cos(AngleVehiculeIMM) sin(AngleVehiculeIMM); -sin(AngleVehiculeIMM) cos(AngleVehiculeIMM)];

% on ramène tout dans le repère absolu
%=======================================
               
P_1=Pos1*MatRot+PosVehicule;
P_2=Pos2*MatRot+PosVehicule;
P_3=Pos3*MatRot+PosVehicule;
P_4=Pos4*MatRot+PosVehicule;
P_5=Pos5*MatRot+PosVehicule;
P_6=Pos6*MatRot+PosVehicule;
P_7=Pos7*MatRot+PosVehicule;
P_8=Pos8*MatRot+PosVehicule;

VehiculeCaisse.x_en=[P_1(1) P_2(1) P_3(1) P_4(1) P_5(1) P_6(1) P_7(1) P_8(1)];
VehiculeCaisse.y_en=[P_1(2) P_2(2) P_3(2) P_4(2) P_5(2) P_6(2) P_7(2) P_8(2)];

% Capot avant                  
							%	P1		 P4
Pos1CAV=[1.1 .85]; 	        %  _______
Pos2CAV=[1.1 -.85]; 	    %	|		 |
Pos3CAV=[2.3 -.6]; 	        %	|      |
Pos4CAV=[2.3 .6]; 	        %	 -------
							% P2		  P3
P_1CAV=Pos1CAV*MatRot+PosVehicule;
P_2CAV=Pos2CAV*MatRot+PosVehicule;
P_3CAV=Pos3CAV*MatRot+PosVehicule;
P_4CAV=Pos4CAV*MatRot+PosVehicule;

VehiculeCaisse.x_en_cav=[P_1CAV(1) P_2CAV(1) P_3CAV(1) P_4CAV(1)];
VehiculeCaisse.y_en_cav=[P_1CAV(2) P_2CAV(2) P_3CAV(2) P_4CAV(2)];

% Capot arriere                  
							%	P1		 P4
Pos1CAR=[-2 .77]; 	        %  _______
Pos2CAR=[-2 -.77]; 	        %	|		 |
Pos3CAR=[-1.4 -.8]; 	    %	|      |
Pos4CAR=[-1.4 .8]; 	        %	 -------
							% P2		  P3
P_1CAR=Pos1CAR*MatRot+PosVehicule;
P_2CAR=Pos2CAR*MatRot+PosVehicule;
P_3CAR=Pos3CAR*MatRot+PosVehicule;
P_4CAR=Pos4CAR*MatRot+PosVehicule;

VehiculeCaisse.x_en_car=[P_1CAR(1) P_2CAR(1) P_3CAR(1) P_4CAR(1)];
VehiculeCaisse.y_en_car=[P_1CAR(2) P_2CAR(2) P_3CAR(2) P_4CAR(2)];


%vitre avant                  
	  						%	P1		 P4
%Pos1VA=[.1 .5]; 		    %  _______
%Pos2VA=[.1 -.5]; 		    %	|		 |
%Pos3VA=[1 -.9]; 		    %	|      |
%Pos4VA=[1 .9]; 		    %	 -------
% P2		  P3
Pos1VA=[.4 .7];
Pos2VA=[.5 .65];
Pos3VA=[.6 .5];
Pos4VA=[.6 -.5];
Pos5VA=[.5 -.65];
Pos6VA=[.4 -.7];

Pos7VA=[.7 -.9];
Pos8VA=[1 -.9];
Pos9VA=[1.1 -.85];
Pos10VA=[1.2 -.8];
Pos11VA=[1.2 .8];
Pos12VA=[1.1 .85];
Pos13VA=[1 .9];
Pos14VA=[.7 .9];
                     
P_1VA=Pos1VA*MatRot+PosVehicule;
P_2VA=Pos2VA*MatRot+PosVehicule;
P_3VA=Pos3VA*MatRot+PosVehicule;
P_4VA=Pos4VA*MatRot+PosVehicule;
P_5VA=Pos5VA*MatRot+PosVehicule;
P_6VA=Pos6VA*MatRot+PosVehicule;
P_7VA=Pos7VA*MatRot+PosVehicule;
P_8VA=Pos8VA*MatRot+PosVehicule;
P_9VA=Pos9VA*MatRot+PosVehicule;
P_10VA=Pos10VA*MatRot+PosVehicule;
P_11VA=Pos11VA*MatRot+PosVehicule;
P_12VA=Pos12VA*MatRot+PosVehicule;
P_13VA=Pos13VA*MatRot+PosVehicule;
P_14VA=Pos14VA*MatRot+PosVehicule;

VehiculeVitres.x_en_va=[P_1VA(1) P_2VA(1) P_3VA(1) P_4VA(1) P_5VA(1) P_6VA(1) P_7VA(1) P_8VA(1) P_9VA(1) P_10VA(1) P_11VA(1) P_12VA(1) P_13VA(1) P_14VA(1)];
VehiculeVitres.y_en_va=[P_1VA(2) P_2VA(2) P_3VA(2) P_4VA(2) P_5VA(2) P_6VA(2) P_7VA(2) P_8VA(2) P_9VA(2) P_10VA(2) P_11VA(2) P_12VA(2) P_13VA(2) P_14VA(2)];


              
% vitre bas                  
							%	P1		 P4
Pos1VB=[-0.2 -.7]; 	        %  _______
Pos2VB=[-0.2 -.9]; 	        %	|		 |
Pos3VB=[.6 -.9]; 		    %	|      |
Pos4VB=[.3 -.7]; 		    %	 -------
							% P2		  P3
P_1VB=Pos1VB*MatRot+PosVehicule;
P_2VB=Pos2VB*MatRot+PosVehicule;
P_3VB=Pos3VB*MatRot+PosVehicule;
P_4VB=Pos4VB*MatRot+PosVehicule;

VehiculeVitres.x_en_vb=[P_1VB(1) P_2VB(1) P_3VB(1) P_4VB(1)];
VehiculeVitres.y_en_vb=[P_1VB(2) P_2VB(2) P_3VB(2) P_4VB(2)];

               
                  
% vitre haut                  
							%	P1		 P4
Pos1VH=[-.2 .7]; 		    %  _______
Pos2VH=[-.2 .9]; 		    %	|		 |
Pos3VH=[.6 .9]; 		    %	|      |
Pos4VH=[.3 .7]; 		    %	 -------
							% P2		  P3
P_1VH=Pos1VH*MatRot+PosVehicule;
P_2VH=Pos2VH*MatRot+PosVehicule;
P_3VH=Pos3VH*MatRot+PosVehicule;
P_4VH=Pos4VH*MatRot+PosVehicule;

VehiculeVitres.x_en_vh=[P_1VH(1) P_2VH(1) P_3VH(1) P_4VH(1)];
VehiculeVitres.y_en_vh=[P_1VH(2) P_2VH(2) P_3VH(2) P_4VH(2)];


              
% vitre arrière bas                  
								%	P1		 P4
Pos1AVB=[-.8 -.7]; 		        %  _______
Pos2AVB=[-1 -.9]; 		        %	|		 |
Pos3AVB=[-.3 -.9]; 		        %	|      |
Pos4AVB=[-.3 -.7]; 		        %	 -------
								% P2		  P3

P_1AVB=Pos1AVB*MatRot+PosVehicule;
P_2AVB=Pos2AVB*MatRot+PosVehicule;
P_3AVB=Pos3AVB*MatRot+PosVehicule;
P_4AVB=Pos4AVB*MatRot+PosVehicule;

VehiculeVitres.x_en_avb=[P_1AVB(1) P_2AVB(1) P_3AVB(1) P_4AVB(1)];
VehiculeVitres.y_en_avb=[P_1AVB(2) P_2AVB(2) P_3AVB(2) P_4AVB(2)];


% vitre arrière haut                  
								%	P1		 P4
Pos1AVH=[-.8 .7]; 		        %  _______
Pos2AVH=[-1 .9]; 		        %	|		 |
Pos3AVH=[-.3 .9]; 		        %	|      |
Pos4AVH=[-.3 .7]; 		        %	 -------
								% P2		  P3
P_1AVH=Pos1AVH*MatRot+PosVehicule;
P_2AVH=Pos2AVH*MatRot+PosVehicule;
P_3AVH=Pos3AVH*MatRot+PosVehicule;
P_4AVH=Pos4AVH*MatRot+PosVehicule;

VehiculeVitres.x_en_avh=[P_1AVH(1) P_2AVH(1) P_3AVH(1) P_4AVH(1)];
VehiculeVitres.y_en_avh=[P_1AVH(2) P_2AVH(2) P_3AVH(2) P_4AVH(2)];

   
%vitre arrière                  
  						        %	P1		 P4
%Pos1VAR=[-1.8 .9]; 		    %  _______
%Pos2VAR=[-1.8 -.9]; 		    %	|		 |
%Pos3VAR=[-1.1 -.5]; 		    %	|      |
%Pos4VAR=[-1.1 .5]; 		    %	 -------
						        % P2		  P3
                        
Pos1VAR=[-.9 .7];
Pos2VAR=[-1 .65];
Pos3VAR=[-1.1 .5];
Pos4VAR=[-1.1 -.5];
Pos5VAR=[-1 -.65];
Pos6VAR=[-.9 -.7];

Pos7VAR=[-1.1 -.9];
Pos8VAR=[-1.3 -.9];
Pos9VAR=[-1.35 -.85];
Pos10VAR=[-1.40 -.8];
Pos11VAR=[-1.40 .8];
Pos12VAR=[-1.35 .85];
Pos13VAR=[-1.3 .9];
Pos14VAR=[-1.1 .9];
                        
P_1VAR=Pos1VAR*MatRot+PosVehicule;
P_2VAR=Pos2VAR*MatRot+PosVehicule;
P_3VAR=Pos3VAR*MatRot+PosVehicule;
P_4VAR=Pos4VAR*MatRot+PosVehicule;
P_5VAR=Pos5VAR*MatRot+PosVehicule;
P_6VAR=Pos6VAR*MatRot+PosVehicule;
P_7VAR=Pos7VAR*MatRot+PosVehicule;
P_8VAR=Pos8VAR*MatRot+PosVehicule;
P_9VAR=Pos9VAR*MatRot+PosVehicule;
P_10VAR=Pos10VAR*MatRot+PosVehicule;
P_11VAR=Pos11VAR*MatRot+PosVehicule;
P_12VAR=Pos12VAR*MatRot+PosVehicule;
P_13VAR=Pos13VAR*MatRot+PosVehicule;
P_14VAR=Pos14VAR*MatRot+PosVehicule;
                  
VehiculeVitres.x_en_var=[P_1VAR(1) P_2VAR(1) P_3VAR(1) P_4VAR(1) P_5VAR(1) P_6VAR(1) P_7VAR(1) P_8VAR(1) P_9VAR(1) P_10VAR(1) P_11VAR(1) P_12VAR(1) P_13VAR(1) P_14VAR(1)];
VehiculeVitres.y_en_var=[P_1VAR(2) P_2VAR(2) P_3VAR(2) P_4VAR(2) P_5VAR(2) P_6VAR(2) P_7VAR(2) P_8VAR(2) P_9VAR(2) P_10VAR(2) P_11VAR(2) P_12VAR(2) P_13VAR(2) P_14VAR(2)];


% phare avant haut                  
								%	P1		 P4
Pos1PAVH=[2.2 1]; 		        %  _______
Pos2PAVH=[2.2 .7]; 		        %	|		 |
Pos3PAVH=[2.3 .7]; 		        %	|      |
Pos4PAVH=[2.3 .9]; 		        %	 -------
								% P2		  P3
P_1PAVH=Pos1PAVH*MatRot+PosVehicule;
P_2PAVH=Pos2PAVH*MatRot+PosVehicule;
P_3PAVH=Pos3PAVH*MatRot+PosVehicule;
P_4PAVH=Pos4PAVH*MatRot+PosVehicule;

VehiculeCaisse.x_en_pavh=[P_1PAVH(1) P_2PAVH(1) P_3PAVH(1) P_4PAVH(1)];
VehiculeCaisse.y_en_pavh=[P_1PAVH(2) P_2PAVH(2) P_3PAVH(2) P_4PAVH(2)];

% phare avant bas                  
								%	P1		 P4
Pos1PAVB=[2.2 -1]; 		        %  _______
Pos2PAVB=[2.2 -.7]; 		    %	|		 |
Pos3PAVB=[2.3 -.7]; 		    %	|      |
Pos4PAVB=[2.3 -.9]; 		    %	 -------
								% P2		  P3
P_1PAVB=Pos1PAVB*MatRot+PosVehicule;
P_2PAVB=Pos2PAVB*MatRot+PosVehicule;
P_3PAVB=Pos3PAVB*MatRot+PosVehicule;
P_4PAVB=Pos4PAVB*MatRot+PosVehicule;

VehiculeCaisse.x_en_pavb=[P_1PAVB(1) P_2PAVB(1) P_3PAVB(1) P_4PAVB(1)];
VehiculeCaisse.y_en_pavb=[P_1PAVB(2) P_2PAVB(2) P_3PAVB(2) P_4PAVB(2)];


% MODELISATION DES ROUES
%=========================
%angle_roue=var_teta_c;
%angle_roue=angle_vehicule/2;
angle_roue=0;

% repère roue
  							%	P1		 P4
ROUE1=[-.4 .15]; 		    %   _______
ROUE2=[-.4 -.15]; 		    %	|		 |
ROUE3=[.4 -.15]; 		    %	|      |
ROUE4=[.4 .15]; 		    %	-------
							% P2		  P3
                     
MatRotRoue=[cos(angle_roue) sin(angle_roue); -sin(angle_roue) cos(angle_roue)];    
                     
% modélisation des roues (AVH)
PRAVH=[1.6 1];		% position de la roue dans le repère véhicule
R1AVH=ROUE1*MatRotRoue+PRAVH;
R2AVH=ROUE2*MatRotRoue+PRAVH;
R3AVH=ROUE3*MatRotRoue+PRAVH;
R4AVH=ROUE4*MatRotRoue+PRAVH;
                     
P_R1AVH=R1AVH*MatRot+PosVehicule;
P_R2AVH=R2AVH*MatRot+PosVehicule;
P_R3AVH=R3AVH*MatRot+PosVehicule;
P_R4AVH=R4AVH*MatRot+PosVehicule;
                  
VehiculeRoues.x_en_ravh=[P_R1AVH(1) P_R2AVH(1) P_R3AVH(1) P_R4AVH(1)];
VehiculeRoues.y_en_ravh=[P_R1AVH(2) P_R2AVH(2) P_R3AVH(2) P_R4AVH(2)];

% modélisation des roues (AVB)

PRAVB=[1.6 -1];                     
R1AVB=ROUE1*MatRotRoue+PRAVB;
R2AVB=ROUE2*MatRotRoue+PRAVB;
R3AVB=ROUE3*MatRotRoue+PRAVB;
R4AVB=ROUE4*MatRotRoue+PRAVB;
                     
P_R1AVB=R1AVB*MatRot+PosVehicule;
P_R2AVB=R2AVB*MatRot+PosVehicule;
P_R3AVB=R3AVB*MatRot+PosVehicule;
P_R4AVB=R4AVB*MatRot+PosVehicule;
                  
VehiculeRoues.x_en_ravb=[P_R1AVB(1) P_R2AVB(1) P_R3AVB(1) P_R4AVB(1)];
VehiculeRoues.y_en_ravb=[P_R1AVB(2) P_R2AVB(2) P_R3AVB(2) P_R4AVB(2)];

% modélisation des roues (ARH)
  								%	P1		 P4
R1ARH=[-1 1.15]; 			    %  _______
R2ARH=[-1 .95]; 			    %	|		 |
R3ARH=[-1.8 .95]; 		        %	|      |
R4ARH=[-1.8 1.15]; 		        %	-------
								% P2		  P3
                     
P_R1ARH=R1ARH*MatRot+PosVehicule;
P_R2ARH=R2ARH*MatRot+PosVehicule;
P_R3ARH=R3ARH*MatRot+PosVehicule;
P_R4ARH=R4ARH*MatRot+PosVehicule;
                  
VehiculeRoues.x_en_rarh=[P_R1ARH(1) P_R2ARH(1) P_R3ARH(1) P_R4ARH(1)];
VehiculeRoues.y_en_rarh=[P_R1ARH(2) P_R2ARH(2) P_R3ARH(2) P_R4ARH(2)];

% modélisation des roues (ARB)
  								%	P1		 P4
R1ARB=[-1 -1.15]; 		        %  _______
R2ARB=[-1 -.95]; 			    %	|		 |
R3ARB=[-1.8 -.95]; 		        %	|      |
R4ARB=[-1.8 -1.15]; 		    %	 -------
								% P2		  P3
                     
P_R1ARB=R1ARB*MatRot+PosVehicule;
P_R2ARB=R2ARB*MatRot+PosVehicule;
P_R3ARB=R3ARB*MatRot+PosVehicule;
P_R4ARB=R4ARB*MatRot+PosVehicule;
                  
VehiculeRoues.x_en_rarb=[P_R1ARB(1) P_R2ARB(1) P_R3ARB(1) P_R4ARB(1)];
VehiculeRoues.y_en_rarb=[P_R1ARB(2) P_R2ARB(2) P_R3ARB(2) P_R4ARB(2)];

