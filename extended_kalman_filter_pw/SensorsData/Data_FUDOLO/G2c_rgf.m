function [X,Y,Z] = g2c_rgf(longitude,latitude,h)

%G2C_RGF transforme les coordonnees geographiques en cartesiennes pour le RGF
%	ces coordonnees peuvent etre scalaires ou vectorielles
%	longitude,latitude,h : rad et m
%	X,Y,Z : m
%
%	Matlab fonction vectorielle
%
%	[X,Y,Z] = g2c_rgf(longitude,latitude,h)
%
%	voir aussi : G2C_NTF

% G. Hintzy et D. Betaille - juillet 96
% D. Betaille - mai 01

%-------------------------------------------------------------------------------

GRS_a = 6378137;
%GRS_f = 1/298.2572236;
GRS_f = 1/298.257222101;
GRS_b = GRS_a*(1-GRS_f);
GRS_e = sqrt((GRS_a^2 - GRS_b^2) / (GRS_a^2));

N = GRS_a ./ sqrt(1 - GRS_e^2 .* (sin(latitude)).^2);
X = (N + h) .* cos(latitude) .* cos(longitude);
Y = (N + h) .* cos(latitude) .* sin(longitude);
Z = (N * (1 - GRS_e^2) + h) .* sin(latitude);

%-------------------------------------------------------------------------------
% fin de g2c_rgf
%-------------------------------------------------------------------------------
