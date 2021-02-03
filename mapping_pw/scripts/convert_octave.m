# -------------------------------------------------------
# Code pour lire un fichier Geoportail kml
# et convertir ses coordonnees en Lambert 93
# -------------------------------------------------------
# Parametres de calcul de projection issus de
# https://geodesie.ign.fr/contenu/fichiers/documentation/
# pedagogiques/TransformationsCoordonneesGeodesiques.pdf
# -------------------------------------------------------

# --------------------------------------------
# Parametres
# --------------------------------------------
input = "test.kml";   # Fichier kml a lire


# --------------------------------------------
# Fonction de calcul latitude isometrique
# --------------------------------------------
function[L]=latiso(phi)
E=0.08181919106;
L=log(tan(pi/4+phi/2)*((1-E*sin(phi))/(1+E*sin(phi)))^(E/2));
endfunction


# --------------------------------------------
# Fonction de projection WGS 84 -> Lambert 93
# --------------------------------------------
# Entrees : lambda et phi, longitude et
# latitdue en degrees decimaux WGS84
# Sorties : X et Y, coordonnees Lambert 93
# --------------------------------------------
function[X,Y]=lambert93(lambda,phi)
lambda = lambda*pi/180.0;
phi = phi*pi/180.0;
Xp=700000.000;
Yp=12655612.050;
n=0.725607765053267;
C=11754255.4260960;
lambda0=0.0523598775598299;
X=Xp+C*exp(-n*latiso(phi))*sin(n*(lambda-lambda0));
Y=Yp-C*exp(-n*latiso(phi))*cos(n*(lambda-lambda0));
endfunction

# --------------------------------------------
# Lecture du fichier ligne par ligne
# --------------------------------------------

printf("--------------------------------------------------------------------------------\r\n")
printf("Input file: %s\r\n", input)
printf("--------------------------------------------------------------------------------\r\n")

L93 = [];

fid = fopen(input);
tline = fgetl(fid);
count = 1;
index = -9999;

while ischar(tline)
 
    if (strfind(tline, "<description>") > 0)
      tline = substr(tline,17,length(tline)-16);
      tline = substr(tline,1,length(tline)-14);
      index = str2num(tline);
    endif
 
    if (strfind(tline, "<coordinates>") > 0)
     
      # Lecture des coordonnees
      tline = substr(tline,18,length(tline)-17);
      tline = substr(tline,1,length(tline)-14);
      coords = strsplit(tline,",");
      longitude = str2num(coords(1,1){1});
      latitude = str2num(coords(1,2){1});
     
      printf("Point %d: Lon = %3.8d; Lat = %3.8d",
        count, longitude, latitude);
   
      # Conversion en Lambert 93
      [X,Y] = lambert93(longitude, latitude);
      printf(" > X = %3.8d; Y = %3.8d  #%d\r\n",
       X, Y, index);
     
      L93(count,:) = [index,X,Y];
      count = count + 1;
     
    endif
    tline = fgetl(fid);

end

# Sauvegarde
save test.dat L93;

printf("--------------------------------------------------------------------------------\r\n")
