function [x,y,z] = cart2tan(X1,Y1,Z1,X,Y,Z)

%CART2TAN transforme les coordonnees cartesiennes en coordonnees tangentes
%	a l'ellipsoide RGF en le point de coordonnees cartesiennes X1 Y1 Z1
%	ces coordonnees peuvent etre scalaires ou vectorielles
%
%	Matlab fonction
%
%	[x,y,z] = cart2tan(X1,Y1,Z1,X,Y,Z)
%
%	voir aussi : TAN2CART, C2G_RGF

% D. Betaille - janvier 01

%-------------------------------------------------------------------------------

[long1,lat1,alt1] = c2g_rgf(X1,Y1,Z1);

alf = long1;
bet = lat1;

R = [-sin(alf) cos(alf) 0;...
-sin(bet)*cos(alf) -sin(bet)*sin(alf) cos(bet);...
cos(bet)*cos(alf) cos(bet)*sin(alf) sin(bet)];

S = [X1*sin(alf)-Y1*cos(alf);...
X1*sin(bet)*cos(alf)+Y1*sin(bet)*sin(alf)-Z1*cos(bet);...
-X1*cos(bet)*cos(alf)-Y1*cos(bet)*sin(alf)-Z1*sin(bet)];

if size(X,1)>size(X,2),
	X=X';
end;
if size(Y,1)>size(Y,2),
	Y=Y';
end;
if size(Z,1)>size(Z,2),
	Z=Z';
end;

toto = R*[X;Y;Z];
x = toto(1,:)+S(1);
y = toto(2,:)+S(2);
z = toto(3,:)+S(3);

%-------------------------------------------------------------------------------
% fin de cart2tan
%-------------------------------------------------------------------------------
