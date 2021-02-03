function BetP = calcul_BetP3classes(I)
% Rappel Def : BetP(omega) = somme ( m(A)/|A| ) pour tout A tel que omega appartient à A.

dim=log2(size(I,3));
BetP = ones(size(I,1),size(I,2),dim);

for i=1:size(I,1)
   for j=1:size(I,2)
       
           BetP(i,j,1) = I(i,j,1) + I(i,j,3)/2 + I(i,j,5)/2 + I(i,j,7)/3;
           BetP(i,j,2) = I(i,j,2) + I(i,j,3)/2 + I(i,j,6)/2 + I(i,j,7)/3;
           BetP(i,j,3) = I(i,j,3) + I(i,j,5)/2 + I(i,j,6)/2 + I(i,j,7)/3;
  
   end
end

end
