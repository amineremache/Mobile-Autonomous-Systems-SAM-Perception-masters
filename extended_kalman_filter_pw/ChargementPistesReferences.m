%****************************************************************************************
% ChargementPistesReferences
% Module de chargement des pistes de reference de Satory:
%       Piste de la routière
%       Piste du val d'or 
% (c) LIVIC 2007
% 
% Ce fichier est la propriete du LIVIC. Toute utilisation, copie partielle ou
% totale, modification du fichier sans autorisation du LIVIC est interdite.
% 
% Fichier          : $RCSfile: ChargementPistesReferences.m,v $
% Date de creation : 2007/25/03
% Auteur           : Dominique Gruyer 
% Modifie le       : $Date: 2007/25/03 10:00:00 $ par $Author: Dominique Gruyer$
% Version          : $Revision: 0.00 $													
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%****************************************************************************************/
function [PisteRoutiere,PisteValdOr]=ChargementPistesReferences( ReferenceGPS, Mode); 
% Si Mode = 1 alors on prend en compte la reference GPS sinon on prend le
% premier point de la piste.

load TracksData/ValdOr3Dm.mat;      % Coordonnées de la piste du val d'or   ( Variable PisteValDOr )
load TracksData/MarqRout3Dm.mat;    % Coordonnées de la piste routière      ( Variable PisteRoutiere )
PisteRoutiere   = struct('xc',[],'yc',[],'zc',[],'xd',[],'yd',[],'zd',[],'xg',[],'yg',[],'zg',[],'ref',[]);
PisteValdOr     = struct('xc',[],'yc',[],'zc',[],'xd',[],'yd',[],'zd',[],'xg',[],'yg',[],'zg',[],'ref',[]);

if Mode
    ReferenceX = ReferenceGPS(1,1);
    ReferenceY = ReferenceGPS(1,2);
    ReferenceZ = ReferenceGPS(1,3);
else
    ReferenceX = PisteRoutiere3D(1,1);
    ReferenceY = PisteRoutiere3D(1,2);
    ReferenceZ = PisteRoutiere3D(1,3);
end;

%fprintf(' Le premier Point de la piste est XCentre: %6.3f  YCentre: %6.3f ZCentre: %6.3f\n', PisteRoutiere3D(1,1) ,PisteRoutiere3D(1,2) ,PisteRoutiere3D(1,3) );

PisteRoutiere.ref = [ReferenceX ReferenceY ReferenceZ];
PisteRoutiere.xc = PisteRoutiere3D(:,1) - ReferenceX;
PisteRoutiere.yc = PisteRoutiere3D(:,2) - ReferenceY;
PisteRoutiere.zc = PisteRoutiere3D(:,3) - ReferenceZ;
PisteRoutiere.xd = PisteRoutiere3D(:,4) - ReferenceX;
PisteRoutiere.yd = PisteRoutiere3D(:,5) - ReferenceY;
PisteRoutiere.zd = PisteRoutiere3D(:,6) - ReferenceZ;
PisteRoutiere.xg = PisteRoutiere3D(:,7) - ReferenceX;
PisteRoutiere.yg = PisteRoutiere3D(:,8) - ReferenceY;
PisteRoutiere.zg = PisteRoutiere3D(:,9) - ReferenceZ;

PisteValdOr.ref = [ReferenceX ReferenceY ReferenceZ];
PisteValdOr.xd = PisteValdOr3D(:,1)-ReferenceX;
PisteValdOr.yd = PisteValdOr3D(:,2)-ReferenceY;
PisteValdOr.zd = PisteValdOr3D(:,3)-ReferenceZ;
PisteValdOr.xg = PisteValdOr3D(:,4)-ReferenceX;
PisteValdOr.yg = PisteValdOr3D(:,5)-ReferenceY;
PisteValdOr.zg = PisteValdOr3D(:,6)-ReferenceZ;
PisteValdOr.xc = (PisteValdOr.xd(:,1) + PisteValdOr.xg(:,1))/2;
PisteValdOr.yc = (PisteValdOr.yd(:,1) + PisteValdOr.yg(:,1))/2;
PisteValdOr.zc = (PisteValdOr.zd(:,1) + PisteValdOr.zg(:,1))/2;

clear PisteRoutiere3D;
clear PisteValdOr3D;