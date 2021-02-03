% -------------------------------------------------------
% Code pour lire un fichier Geoportail kml
% et convertir ses coordonnees en Lambert 93
% -------------------------------------------------------
% Parametres de calcul de projection issus de
% https://geodesie.ign.fr/contenu/fichiers/documentation/
% pedagogiques/TransformationsCoordonneesGeodesiques.pdf
% -------------------------------------------------------
% ATTENTION : version Matlab
% -------------------------------------------------------

% -------------------------------------------------------
% Parametres
% -------------------------------------------------------
input = 'data/test_3.4.kml';   % Fichier kml a lire
output = 'data/test_3.4.dat';
% -------------------------------------------------------
E=0.08181919106;
Xp=700000.000;
Yp=12655612.050;
n=0.725607765053267;
C=11754255.4260960;
lambda0=0.0523598775598299;
% -------------------------------------------------------

% --------------------------------------------
% Lecture du fichier ligne par ligne
% --------------------------------------------

fprintf('--------------------------------------------------------------------------------------\n');
fprintf('Input file: %s\n', input);
fprintf('--------------------------------------------------------------------------------------\n');

L93 = [];

fid = fopen(input);
tline = fgetl(fid);
count = 1;
index = -9999;

while ischar(tline)
 
    if (strfind(tline, '<description>') > 0)
      tline = tline(17:(length(tline)-14));
      index = str2num(tline);
    end
 
    if (strfind(tline, '<coordinates>') > 0)
    
      % Lecture des coordonnees
     
      tline = tline(18:(length(tline)-14));
      coords = strsplit(tline,',');
  
      longitude = str2num(coords{1});
      latitude = str2num(coords{2});
    
      fprintf('Point %d: Lon = %3.5d; Lat = %3.5d', count, longitude, latitude);
  
      % Conversion en Lambert 93
      lambda = longitude*pi/180.0;
      phi = latitude*pi/180.0;

      L=log(tan(pi/4+phi/2)*((1-E*sin(phi))/(1+E*sin(phi)))^(E/2));
      X=Xp+C*exp(-n*L)*sin(n*(lambda-lambda0));
      Y=Yp-C*exp(-n*L)*cos(n*(lambda-lambda0));
      fprintf(' > X = %3.5d; Y = %3.5d  #%d \n', X, Y, index);
    
      L93(count,:) = [index,X,Y];
      count = count + 1;
    
    end
    tline = fgetl(fid);

end

% Sauvegarde
%save(output, 'L93');
writematrix(L93, output);
fprintf('--------------------------------------------------------------------------------------\r\n');