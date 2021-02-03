%****************************************************************************************
% InitialisationPosition
% Module d'initialisation de localisation par approche EKF
% 
% Fichier          : $RCSfile: InitialisationPosition.m,v $
% Auteur           : Dominique Gruyer 									
%	
% Auteurs :
%  Dominique Gruyer: 	1) Developpement du code principal
%						2) Initialisation des vecteurs d'état et des matrices de variance/covariance
%
%****************************************************************************************/

function [xi,yi,ti] = InitialisationPosition(Data,Piste,Indices,Offset);
%   Data = struct('gps',[],'angleroue',[],'ins',[],'gyro',[],'topo',[],'compass',[]);
%   gps         =   struct('x',[],'y',[],'z',[],'HDOP',[],'mode',[],'timeUTC',[],'timeRTMaps',[]);
%   angleroue   =   struct('angle',[],'timeUTC',[],'timeRTMaps',[]);
%   ins         =   struct('gyroscope',[], 'gyrometre',[],'acc',[],'timeUTC',[],'timeRTMaps',[]); 
%   gyro        =   struct('gyrometre',[],'timeUTC',[],'timeRTMaps',[]);
%   topo        =   struct('topo',[],'vitesse',[],'timeUTC',[],'timeRTMaps',[]);
%   compass     =   struct('compass',[],'timeUTC',[],'timeRTMaps',[]);
%================================================================
%   Piste = struct('xc',[],'yc',[],'zc',[],'xd',[],'yd',[],'zd',[],'xg',[],'yg',[],'zg',[]);
%================================================================
% Indices=[Topo INS Gyro compass GPS]
%================================================================

disp('Les données des capteurs à l''instant initial:');

if (Data.topo.topo)
fprintf(' Le Topo--> Tics: %f \n TimeUTC(s): %6.3f \n', Data.topo.topo(Indices(1,1)), ...
                                                        Data.topo.timeUTC(Indices(1,1))/1000000);
% disp([' Le Topo--> Tics: ', num2str(Data.topo.topo(Indices(1,1))),...
%                  ' TimeUTC: ',num2str(Data.topo.timeUTC(Indices(1,1)))]);       
end;
if (Data.ins.gyrometre)
fprintf(' L''INS--> vX: %f vY: %f vZ: %f accX: %f accY: %f accZ: %f \n TimeUTC(s): %6.3f \n',   Data.ins.gyrometre(Indices(1,2),1),...
                                                                                                Data.ins.gyrometre(Indices(1,2),2),...
                                                                                                Data.ins.gyrometre(Indices(1,2),3),...
                                                                                                Data.ins.acc(Indices(1,2),1),...
                                                                                                Data.ins.acc(Indices(1,2),2),...
                                                                                                Data.ins.acc(Indices(1,2),3),...
                                                                                                Data.ins.timeUTC(Indices(1,2))/1000000);
% disp([' L''INS--> vX: ', num2str(Data.ins.gyrometre(Indices(1,2),1)),...
%         ' vY: ', num2str(Data.ins.gyrometre(Indices(1,2),2)),...
%         ' vZ: ', num2str(Data.ins.gyrometre(Indices(1,2),3)),...
%         ' accY: ', num2str(Data.ins.acc(Indices(1,2),1)),...
%         ' accZ: ', num2str(Data.ins.acc(Indices(1,2),2)),...
%         ' accZ: ', num2str(Data.ins.acc(Indices(1,2),3)),...
%         ' TimeUTC: ',num2str(Data.ins.timeUTC(Indices(1,2)))]);
end;
if (Data.gyro.gyrometre)
fprintf(' Le Gyrometre--> vZ: %f \n TimeUTC(s): %6.3f \n',  Data.gyro.gyrometre(Indices(1,3)),...
                                                            Data.gyro.timeUTC(Indices(1,3))/1000000);
% disp([' Le Gyro--> vZ: ', num2str(Data.gyro.gyrometre(Indices(1,3))),...
%         ' TimeUTC: ',num2str(Data.gyro.timeUTC(Indices(1,3)))]);
end;
if (Data.compass.compass)
fprintf(' Le Compass--> Z: %f \n TimeUTC(s): %6.3f \n',     Data.compass.compass(Indices(1,4)),...
                                                            Data.compass.timeUTC(Indices(1,4))/1000000);
% disp([' Le Compass--> Z: ', num2str(Data.compass.compass(Indices(1,4))),...
%         ' TimeUTC: ',num2str(Data.compass.timeUTC(Indices(1,4)))]);
end;
if (Data.gps.x)
fprintf(' Le GPS--> X: %f Y: %f Z: %f \n TimeUTC(s): %6.3f \n', Data.gps.x(Indices(1,5)),...
                                                                Data.gps.y(Indices(1,5)),...
                                                                Data.gps.z(Indices(1,5)),...
                                                                Data.gps.timeUTC(Indices(1,5))/1000000);
% disp([' Le GPS--> X: ', num2str(Data.gps.x(Indices(1,5))),...
%                 ' Y: ', num2str(Data.gps.y(Indices(1,5))),...
%                 ' Z: ', num2str(Data.gps.x(Indices(1,5))),...
%                 ' TimeUTC: ',num2str(Data.gps.timeUTC(Indices(1,5)))]);
end;

% POSITION ET CAP INITIAUX 
%==============================================
% on cherche la donnée GPS Courante et on fait une moyenne afin de
% connaitre la position initiale
xi=mean(Data.gps.x(Indices(1,5)-Offset+1:Indices(1,5)));
yi=mean(Data.gps.y(Indices(1,5)-Offset+1:Indices(1,5)));

disp(' initialisation avec les données de la piste ');
[MinAxeCentralDroit,IndPisteAxeCentralDroit]=min((Piste.xd-xi).^2+(Piste.yd-yi).^2);
[MinAxeCentralGauch,IndPisteAxeCentralGauch]=min((Piste.xg-xi).^2+(Piste.yg-yi).^2);
[Poubelle,IndiceMin]=min([MinAxeCentralDroit;MinAxeCentralGauch]);

if IndiceMin==1,
    disp(' on se trouve sur la voie de droite ..............');
    xi = (Piste.xc(IndPisteAxeCentralDroit)+Piste.xd(IndPisteAxeCentralDroit))/2;
    yi = (Piste.yc(IndPisteAxeCentralDroit)+Piste.yd(IndPisteAxeCentralDroit))/2;
    ti = atan2(   Piste.yc(IndPisteAxeCentralDroit)-Piste.yc(IndPisteAxeCentralDroit-1),...
                  Piste.xc(IndPisteAxeCentralDroit)-Piste.xc(IndPisteAxeCentralDroit-1));
else,
    disp(' on se trouve sur la voie de gauche ..............');
    xi = (Piste.xc(IndPisteAxeCentralGauch)+Piste.xg(IndPisteAxeCentralGauch))/2;
    yi = (Piste.yc(IndPisteAxeCentralGauch)+Piste.yg(IndPisteAxeCentralGauch))/2;
    ti = atan2(   Piste.yc(IndPisteAxeCentralDroit-1)-Piste.yc(IndPisteAxeCentralDroit),...
                  Piste.xc(IndPisteAxeCentralDroit-1)-Piste.xc(IndPisteAxeCentralDroit));
end

fprintf('\nCap initiale avec la carte: ti=%3.5f(deg)\n\n',(ti*180)/pi);

%ti = mean(Data.compass.compass(Indices(1,4)-Offset+1:Indices(1,4)));

fprintf('\nPosition initiale par GPS: (xi=%f, yi=%f)\n',xi,yi);
%fprintf('\nCap initiale avec la carte: ti=%3.5f(deg)\n\n',ti);

