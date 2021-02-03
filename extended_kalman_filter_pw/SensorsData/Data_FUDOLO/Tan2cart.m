function [X,Y,Z] = tan2cart(X1,Y1,Z1,x,y,z)

%TAN2CART transforme en coordonnees cartesiennes les coordonnees tangentes
%	a l'ellipsoide RGF en le point de coordonnees cartesiennes X1 Y1 Z1
%	ces coordonnees peuvent etre scalaires ou vectorielles
%
%	Matlab fonction
%
%	[X,Y,Z] = tan2cart(X1,Y1,Z1,x,y,z)
%
%	voir aussi : CART2TAN, C2G_RGF

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

if size(x,1)>size(x,2),
	x=x';
end;
if size(y,1)>size(y,2),
	y=y';
end;
if size(z,1)>size(z,2),
	z=z';
end;

toto = inv(R)*[x-S(1);y-S(2);z-S(3)];
X = toto(1,:);
Y = toto(2,:);
Z = toto(3,:);

%-------------------------------------------------------------------------------
% fin de tan2cart
%-------------------------------------------------------------------------------
