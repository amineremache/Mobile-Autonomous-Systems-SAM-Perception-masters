h=0.05;
x=(-1:h:2);

for i=1:100
    hold on
    Y1=niveauplus(x,i);
    Y2=niveaumoins(x,i);
    plot(x,Y1);
    plot(x,Y2);
end
hold off

figure;

x=linspace(-1,2,N);
y=linspace(-1,2,N);
z=zeros(N,N);

for i=1:N
    for j=1:N
        z(i,j)=Jfunc([x(i),y(j)]);
    end
end 

contour(x,y,z,[0:10]);

X0=[0;1];
Beta=0.1;
alphainit=1;
tau=0.3;
N=100;
XN=GradEx1(@Jfunc,@gradJfunc,X0,Beta,alphainit,tau,N);


function XN=GradEx1(J,nablaJ,X0,beta,alphainit,tau,N)
XN=X0;
for i=1:N
d=-nablaJ(X0);
alpha=alphainit;
while (J(X0+alpha*d)>J(X0)-beta*alpha*d'*d)
%on choisit alpha s’il verifie la équation (*)
alpha=alpha*tau;
%tau<1 donc le nouveau alpha est plus petit: blacktracking
end
X0=X0+alpha*d;
XN=[XN,X0]; % concatenation
end
end

function Y1=niveauplus(x,C)
Y1=x.^2+(1./10)*sqrt(C-(x-1).^2);
end

function Y2=niveaumoins(x,C)
Y2=x.^2-(1./10)*sqrt(C-(x-1).^2);
end


function y=gradJfunc(x)
y=[-400*x(1)*(x(2)-x(1)^2)+2*(x(1)-1);
200*x(1)*(x(1)-x(2)^2)];
end

function y=Jfunc(x)
y=100*(x(2)-x(1)^2)^2+(x(1)-1)^2;
end


function XN=GradEx2(J,nablaJ,X0,Beta,Beta2,alphainit,tau1,tau2,N)
    for i=1:N
        d=-nablaJ(X0);
        alpha=alphainit;
        continuer = true(1,1);
        n=0;
        while continuer && n<1000
            continuer = false(1,1);
            n=n+1
            if(Beta*alpha*d'*gradrose(X0)<rose(X0+alpha*d)-rose(X0))
            alpha=alpha*tau1;
            continuer = true(1,1);
            end
        if(Beta2*alpha*d'*gradrose(X0)>rose(X0+alpha*d)-rose(X0))
            alpha=alpha*tau2 % pour rester au bord du intervale valide
            continuer = true(1,1);
        end
        end
        X0=X0+alpha*d;
    end
        XN=X0;
end


function XN=GradEx3(J,nablaJ,X0,Beta,Beta3,alphainit,tau1,tau2,N)
    for i=1:N
        d=-nablaJ(X0);
        alpha=alphainit;
        continuer = true(1,1);
        n=0;
        while continuer && n<1000
            continuer = false(1,1);
            n=n+1
            if(Beta*alpha*d'*nablaJ(X0)<J(X0+alpha*d)-J(X0))
                alpha=alpha*tau1;
                continuer = true(1,1);
            end
            if(nablaJ(X0)>Beta3*nablaJ([0,0]))
                alpha=alpha*tau2;
                continuer = true(1,1);
            end
        end
        X0=X0+alpha*d;
    end
    XN=X0;
end

function XN=NewEx4(J,nablaJ,HJ,X0,N)
    XN=X0;
    for i=1:N
        d=-inv(HJ(X0))*nablaJ(X0)
        X0=X0+d;
        XN=[XN,X0];
    end
end


function XN=BFEx5(J,nablaJ,X0,N)
    XN=X0;
    d=-nablaJ(X0); //on multiplie par H=Id la première iteration
    X1=X0+d;
    XN=[XN,X1];
    dk=X1-X0;
    yk=nablaJ(X1)-nablaJ(X0);
    X0=X1;
    for i=2:N
        B=(yk.*yk)/(yk.*dk);
        C=(H*dk*dk’*H)/(dk’*H*dk);
        H=H+B-C;
        d=-H*nablaJ(X0);
        X1=X0+d;
        XN=[XN,X1];
        dk=X1-X0;
        yk=nablaJ(X1)-nablaJ(X0);
    end
end
