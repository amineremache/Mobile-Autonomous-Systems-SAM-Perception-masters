%==========================================================================
% INITIALISATION DES PARAMETRES DU FILTRE EKF
% BruitsSystemeCapteurs = struct( 'SigmaCodeur',SigmaCodeur,...
%                                'SigmaGyro',SigmaGyro,...
%                                'SigmaPsi',SigmaPsi,...
%                                'SigmaModelX',SigmaModelX,...
%                                'SigmaModelY',SigmaModelY,...
%                                'SigmaModelTheta',SigmaModelTheta);
%==========================================================================
[X0,Y0, A0] = InitialisationPosition(Data,PisteRoutiere,Indices,OffSet)

VehiculeNL=struct(	'NoVehicule',1,...
                    'X_E',[X0;Y0;A0],...
                    'P_E',diag([1.0;1.0;0.01]),...
                    'TempsCourant',0);
                
 % GESTION TEMPORELLE DES DONNEES
 %==================================
 [TempsCourant, IndiceCourant] = min([  Data.topo.timeUTC(Indices(1)) ...
                                        Data.ins.timeUTC(Indices(2)) ...
                                        Data.gyro.timeUTC(Indices(3)) ...
                                        Data.compass.timeUTC(Indices(4)) ...
                                        Data.angleroue.timeUTC(Indices(5)) ...
                                        Data.gps.timeUTC(Indices(6)) ...
                                        Data.rtk.timeUTC(Indices(7))]);
                                
VehiculeNL.TempsCourant =   TempsCourant/1000000;
VarSysteme              =   [   BruitsSystemeCapteurs.SigmaCodeur; ...
                                BruitsSystemeCapteurs.SigmaCodeur; ...
                                BruitsSystemeCapteurs.SigmaGyro];
IndiceCourant           =   Indices(1,1);
CapteurUtilise          =   1;
GPSActive               =   1;
NbEtape                 =   0;

%==========================================================
% Etat du GPS: est ce qu'il est valide, quel est son mode de
% fonctionnement, quelles sont ces variances (axes X et Y),
% Quelle est sa rotation.
%  Mode GPS, 1 gps naturel, 2 différentiel EGNOS, 0 masquage
%=========================================================
if (strcmp(Data.gps.type,'AG132'))
    if isempty( Data.gps.valide )
        ModeGPS     = Data.gps.mode(Indices(1,5));
        Valide      = 1;
        SigmaA      = 0;
        SigmaB      = 0;
        Phi         = 0;
    else
        Valide      = Data.gps.valide(Indices(1,5));
        ModeGPS     = Data.gps.mode(Indices(1,5));
        SigmaA      = Data.gps.a(Indices(1,5));
        SigmaB      = Data.gps.b(Indices(1,5));
        Phi         = Data.gps.phi(Indices(1,5));
    end;
else
    ModeGPS         = 1;
    Valide          = 1;
    SigmaA          = 0;
    SigmaB          = 0;
    Phi             = 0;
end;

Q_GPS = InitBruitGPS( Valide, ModeGPS, SigmaA, SigmaB, Phi);
