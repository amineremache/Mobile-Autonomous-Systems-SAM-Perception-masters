function [longitude,latitude,h] = c2g_rgf(X,Y,Z)

%C2G_RGF transforme les coordonnees cartesiennes en geographiques pour le RGF
%	ces coordonnees peuvent etre scalaires ou vectorielles
%	longitude,latitude,h : rad et m
%	X,Y,Z : m
%
%	Matlab fonction vectorielle
%
%	[longitude,latitude,h] = c2g_rgf(X,Y,Z)
%
%	voir aussi : C2G_NTF

% G. Hintzy et D. Betaille - juillet 96
% D. Betaille - mai 01

%-------------------------------------------------------------------------------

GRS_a = 6378137;
%GRS_f = 1/298.2572236;
GRS_f = 1/298.257222101;
GRS_b = GRS_a*(1-GRS_f);
GRS_e = sqrt((GRS_a^2 - GRS_b^2) / (GRS_a^2));

p = sqrt(X.*X + Y.*Y);			% utilitaire de calcul

longitude = 2*atan(Y./(X+p));		% longitude directement

phiOld = atan(Z./p);			% latitude a iterer
w = sqrt(1 - GRS_e^2*(sin(phiOld).^2));
N = GRS_a ./ w;
h = p.*cos(phiOld) + Z.*sin(phiOld) - GRS_a*w;
phiNew = atan((Z./p).*((1-N*GRS_e^2./(N+h)).^(-1)));

while max(abs(phiOld-phiNew)) > 1e-10,
	  I = find(abs(phiOld-phiNew) > 1e-10);
	  phiOld(I) = phiNew(I);
	  w = sqrt(1 - GRS_e^2*(sin(phiOld(I)).^2));
	  N = GRS_a ./ w;
	  h(I) = p(I).*cos(phiOld(I)) + Z(I).*sin(phiOld(I)) - GRS_a*w;
	  phiNew(I) = atan((Z(I)./p(I)).*((1-N*GRS_e^2./(N+h(I))).^(-1)));
end;

latitude = phiNew;

%-------------------------------------------------------------------------------
% fin de c2g_rgf
%-------------------------------------------------------------------------------
