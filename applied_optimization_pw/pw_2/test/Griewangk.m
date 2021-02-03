function Y = Griewangk (X)
    % Griewangk's function in 2 dimensions
    
    m=2;  % Dimension
	d=0;
	f=1;
	for e=1:m
		d=d+X(e)^2/4000;
		f=f*cos(X(e)/(e^0.5));
	end
	
	Y=d-f+1;

end