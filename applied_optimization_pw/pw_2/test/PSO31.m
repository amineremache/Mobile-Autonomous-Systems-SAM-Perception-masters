    clear all;
    clc;

    c1=2;				% Learning factor 1
    c2=2;				% Golbal Learning factor 2
    W_max=1;			% Maximum weight
    W_min=0;			% Minimum weight
    I_max=200;			% Maximum iteration
    N=2;				% Numer of dimension
    M=50;				% Number of Particle
    Run=1;              % The number of test time
    X_max= [-0.1,0.1];     % Boundary
	X_min= [-0.1,0.1];   % Boundary
    V_max=1;
	Func=@Griewangk;
    
	for r=1:Run
		% Initialize
		for i=1:M
			 for j=1:N
				 x(i,j)=X_min(j)+rand()*(X_max(j)-X_min(j));
				 v(i,j)=rand()*(X_max(j)-X_min(j));
			 end
			 Fit(i,:)=Func(x(i,:));
			 Pb(i,:)=x(i,:);        % Personal best initialize
		end
		
		% Get the global best
		[gb1,ind1]=sort(Fit);
		Gb=x(ind1(1,1),:);
		
		for t=1:I_max
			% begin to count
			t=t+1; 
			% Update the position and velocity
			for i=1:M
				% Update the Pb
				if Func(x(i,:))<Fit(i)
				   Fit(i)=Func(x(i,:));
				   Pb(i,:)=x(i,:);
				end
				% Update the Gb
				if Func(Gb)>Fit(i)       
				   Gb=Pb(i,:);
				end
				
				% Update the velocity
				% Calculate the weighting function
				w=W_max-(W_max-W_min)*t/I_max;
				v(i,:)=w*v(i,:)+c1*rand*(Pb(i,:)-x(i,:))+c2*rand*(Gb-x(i,:));
				% Check the velocity
				for j=1:N
					if v(i,j)>V_max
					   v(i,j)=V_max;
					elseif v(i,j)<-V_max
					   v(i,j)=-V_max;
					end
				end
				% Update the position
				x(i,:)=x(i,:)+v(i,:);

			end
			Y=Func(Gb);
            
			% Plot, just for look
			figure(1);
			plot(t,Y,'r.');
			xlabel('Iteration');
			ylabel('Fitness');
			title(sprintf('The Best Fitness: %.15f',Y));
			grid on;
			hold on;		

        end
        figure(2);
        PlotG();
        hold on;
        scatter3(Gb(1),Gb(2),Y,'fill','ro');
		hold off;

	end