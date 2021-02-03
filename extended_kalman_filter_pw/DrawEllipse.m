% DRAW_ELLIPSE.M
%
% Emmanuel HALBWACHS
%
% 7/10/93
%
% Cette fonction dessine l'ellipse definie par la matrice A et le vecteur
% xc telle que:
%		      t -1
%		(x-xc) A  (x-xc) = 1
%
%
% Syntaxe: draw_ellipse(xc, A, couleur)
%

function DrawEllipse(xc,A,couleur,taille)

% test de validite des entrees
if length(xc) ~= 2,
	error('le vecteur "centre" n''est pas de dimension 2');
elseif sum(size(xc) ~= [2 1]) ~= 0,
	% on met le vecteur en colonne
	xc = xc';
end
if sum(size(A) ~= [2 2]) ~= 0,
	error('la matrice s''est pas de dimension 2x2');
end
if sum(sum(A-A' > 1e-6*ones(2))) ~= 0,
	error('la matrice n''est pas symetrique');
end
if isstr(couleur) == 0,
	disp('le parametre de couleur doit etre du type "string"');
	return;
end

[P,L] = eig(A);		% P matrice des vecteurs propres
					% L matrice des valeurs propres

if sum(eig(A) < 0) ~= 0,
   %error('la matrice n''est pas semi-definie positive');
   disp('la matrice n''est pas semi-definie positive');
   for i=1:length(L)
      L(i,i)=abs(L(i,i));
   end;
end

axe = 3*sqrt(diag(L));	% 1/2 longueur des axes = racine(valeurs propres)
								% multiplier par 3 pour avoir 99 % de l'écart type

% calcul de l'ellipse dans le repere principal (defini par les vecteurs
% propres) en coordonnees parametriques u=f(t)
t=0:0.1:2*pi+0.1;
u = [ 	axe(1)*cos(t) ;
		axe(2)*sin(t) ];

% changement de repere dans le repere absolu: on passe en coordonnees x
% rotation
x = P*u;

% translation du centre de l'ellipse au point xc
for i=1:size(x,2),
	x(:,i) = x(:,i) + xc;
end

% graphe de l'ellipse en coordonnees parametriques
%etat_hold = ishold;
%if (etat_hold == 0) hold on; end
hndl=plot(x(1,:),x(2,:),couleur);
set(hndl,'LineWidth',taille);
%if (etat_hold == 0) hold off; end
% axis('equal');
% axis([-10 10 -10 10]);
% grid;


