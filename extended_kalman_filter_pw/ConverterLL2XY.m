function [X,Y] = ConverterLL2XY(lat,long)

% lat et long en radians

CSWGS84.Phi=lat;
CSWGS84.Lambda=long;


% Ellipsoide GRD80
    %demi grand axe
    EllWGS84.a=6378137.0;
    %aplatissement
	EllWGS84.f=1.0/298.257223563;
    %demi petit axe
	EllWGS84.b=EllWGS84.a*(1.0-EllWGS84.f);
    %premiere exentricite 
	EllWGS84.e=sqrt((EllWGS84.a*EllWGS84.a-EllWGS84.b*EllWGS84.b)/(EllWGS84.a*EllWGS84.a));
    
    %hauteur au dessus de l'ellipsoide
	%valeur mise par defaut en l'absence d'information sur l'altitude
	CSWGS84.he=212.181;
	
    % passage de coordonnees geographiques en cartesiennes
	CCWGS84=CoordGeoVersCoordCart(CSWGS84,EllWGS84);

    % 3 translations (parametres piste)
    TP.Tx=-168.3308;
    TP.Ty=-58.8051;
    TP.Tz=320.2515;
    
    %3 Rotations
    TP.Rx=0.0;
    TP.Ry=0.0;
    TP.Rz=0.0;
    % facteur d'echelle
    TP.D=0.0;
    
	%changement de reperes cartesiens 
    
    ccartNTF=Trans7Param2SysGeoInv(CCWGS84,TP);
			
	% ellipsoide de clarke
	el.a=6378249.2;     % demi grand axe de l'ellipsoide
			
	el.b=6356515.0;     % demi petit axe de l'ellipsoide
			
	el.e=sqrt((el.a*el.a-el.b*el.b)/(el.a*el.a));     % premiere excentricite de l'ellipsoide

	el.f=(el.a-el.b)/el.a;     % aplatissement
    % passage en coordonnees geographiques 
	NTFgeo=CoordCartVersCoordGeo(ccartNTF, el,0.000000000001);
	CPL=ProjLambTangent(el.a,el.e,((2.0+20.0/60.0+14.025/3600.0)*pi)/180.0,...
						((49.0+30.0/60.0)*pi)/180.0,0.99987734,600000.0,200000.0);
    % projection plane            
    Position=CoordGeoVersLambert(NTFgeo,CPL);
    X = Position.X;
    Y = Position.Y;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function N= NormaleEllipsoide(phi, a, e)
	N=a/(sqrt(1-e*e*sin(phi)*sin(phi)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function U=CoordGeoVersCoordCart(CG, El)
	N=NormaleEllipsoide(CG.Phi,El.a,El.e);
	U.X=(N+CG.he)*cos(CG.Phi)*cos(CG.Lambda);
	U.Y=(N+CG.he)*cos(CG.Phi)*sin(CG.Lambda);
	U.Z=(N*(1-El.e*El.e)+CG.he)*sin(CG.Phi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function U=Trans7Param2SysGeoInv( V, T)
	VV.X=V.X-T.Tx;
	VV.Y=V.Y-T.Ty;
	VV.Z=V.Z-T.Tz;

	e=1+T.D;

	det=e*(e*e+T.Rx*T.Rx+T.Ry*T.Ry+T.Rz*T.Rz);

	U.X=((e*e+T.Rx*T.Rx)*VV.X+(e*T.Rz+T.Rx*T.Ry)*VV.Y+(T.Rx*T.Rz-e*T.Ry)*VV.Z)/det;
	U.Y=((-e*T.Rz+T.Rx*T.Ry)*VV.X+(e*e+T.Ry*T.Ry)*VV.Y+(e*T.Rx+T.Ry*T.Rz)*VV.Z)/det;
	U.Z=((e*T.Ry+T.Rx*T.Rz)*VV.X+(-e*T.Rx+T.Ry*T.Rz)*VV.Y+(e*e+T.Rz*T.Rz)*VV.Z)/det;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function CG=CoordCartVersCoordGeo(CC, El, Er)
	CG.Lambda=atan(CC.Y/CC.X);
	OldPhi=9999.0;
	Phi=atan(CC.Z/(sqrt(CC.X*CC.X+CC.Y*CC.Y)*(1-(El.a*El.e*El.e)/sqrt(CC.X*CC.X+CC.Y*CC.Y+CC.Z*CC.Z))));
	
	while(abs(Phi-OldPhi)>Er)
		OldPhi=Phi;
		temp=1/(1-(El.a*El.e*El.e*cos(OldPhi))/(sqrt(CC.X*CC.X+CC.Y*CC.Y)*sqrt(1-El.e*El.e*sin(OldPhi)*sin(OldPhi))));
		Phi=atan((CC.Z/sqrt(CC.X*CC.X+CC.Y*CC.Y))*temp);
    end
    CG.Phi=Phi;
	CG.he=(sqrt(CC.X*CC.X+CC.Y*CC.Y)/cos(Phi))-((El.a)/(sqrt(1-El.e*El.e*sin(Phi)*sin(Phi))));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function CP=ProjLambTangent(a,e,lambda0,Phi0,k0, X0, Y0)
	CP.lambdac=lambda0;
	CP.n=sin(Phi0);
	CP.C=k0*NormaleEllipsoide(Phi0,a,e)*(1/tan(Phi0))*exp(CP.n*LatIso(Phi0,e));
	CP.Xs=X0;
	CP.Ys=Y0+k0*NormaleEllipsoide(Phi0,a,e)*(1/tan(Phi0));
	CP.e=e;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  function  CL=CoordGeoVersLambert(CG,CP)
	LISO=LatIso(CG.Phi,CP.e);
	CL.X=CP.Xs+CP.C*exp(-CP.n*LISO)*sin(CP.n*(CG.Lambda-CP.lambdac));
	CL.Y=CP.Ys-CP.C*exp(-CP.n*LISO)*cos(CP.n*(CG.Lambda-CP.lambdac));
	CL.Z=CG.he;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function PhiIso=LatIso(Phi, e)
	PhiIso=log(	tan(pi/4.0+Phi/2.0)* ((1-e*sin(Phi))/(1+e*sin(Phi)))^(e/2.0));
