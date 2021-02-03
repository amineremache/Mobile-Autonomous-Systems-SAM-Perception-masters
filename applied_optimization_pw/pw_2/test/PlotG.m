function PlotG()

[X,Y] = meshgrid(-2:2,-2:2);
N = size(X,1);

for i = 1:N
    for j = 1:N
        z = [X(i,j),Y(i,j)];
        Z(i,j) = Griewangk (z);
    end
end

mesh(X,Y,Z);
title('f(x,y)');

end