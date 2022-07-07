% Abelardo Riojas
% ISC 4232 Lab 1
% Prof. Quaife Fall 2020

%[x1, iter] = newtons(1000,@func,@funcp,1e-8,2);
 
% N = [3 6 9 17];
% for i = 1:length(N)
%     n = N(i);
% %     interpX = linspace(-1,1,n); %EQUALLY SPACED
%     interpX = zeros(n,1);
%     for c = 1:n
%         interpX(c) = cos(((2*c-1)/(2*n))*pi); %CHEBYSHEV
%     end
%     interpY = lf(interpX);
%     targetX = linspace(-1,1,500);
%     targetY = zeros(1,500);
%     for j = 1:500
%         targetY(j) = lagrange_interp(interpX,interpY,targetX(j));
%     end
%     sgtitle('Chebyshev Points: f(x) - p(x)')
%     subplot(2,2,i)
%     fxminuspx = lf(targetX) - targetY;
%     plot(targetX,fxminuspx,'LineWidth', 2)
%     xlim([-1 1]);
%     ylim([-1 1]);
%     subptitle = sprintf('n = %d',n);
%     title(subptitle)
%     legend('f(x) - p(x)')
%  end

dts = [1/4 1/8 1/16 1/32 1/64];
errs = zeros(1,length(dts));
for i = 1:length(dts)
    [~,~,err] = Backward_Euler(1,0,1,dts(i),@ode,@partial);
    errs(i) = err;
end
loglog(dts,errs);

% [t,y] = Backward_Euler(1,0,1,(1/16),@ode,@partial)


function [T,Y,err] = Backward_Euler(y0,t0,T,dt,fyt,Fdy)
T = linspace(t0,T,1/dt);
n = length(T);
Y = zeros(1,n);
Y(1) = y0;
for i = 2:n
    Y(i) = Backward_Euler_Step(Y(i-1),T(i),dt,fyt,Fdy);
end
    err = abs(Y(end) - exp((-T(end)^2)/2));
end

function Ynext = Backward_Euler_Step(Yn,tn,dt,fyt,Fdy)
maxiter = 1000;
tol = 1e-6;
G = @(y) y-Yn-dt*fyt(y,tn);
Gdy = @(y) 1-dt*Fdy(y,tn)
Ynext = newtons(maxiter,G,Gdy,tol,Yn);
end


function [T,Y,err] = Forward_Euler(y0,t0,T,dt,fyt)
T = linspace(t0,T,1/dt);
n = length(T);
Y = zeros(1,n);
Y(1) = y0;
yn = y0;
for i = 2:n
    Y(i) = yn + dt*fyt(yn,T(i));
    yn = Y(i);
end
    err = abs(Y(end) - exp((-T(end)^2)/2));
end

function val = ode(yn,tn)
val = -tn * yn;
end

function val = partial(yn,tn)
val = 0;
end


 
function val = lf(x)
val = 1./(1 + (25.*x.^2));
end
 
function val = func(x)
val = x^2 - 1;
end
 
function val = funcp(x)
val = 2*x;
end
 
function [x1, iter] = newtons(maxiter,f,fp,tol,x0)
    iter = 0;
    while iter < maxiter
        x1 = x0 - (f(x0)/fp(x0));
        iter = iter + 1;
        if abs(x1 - x0) <= tol
            break;
        else
            x0 = x1;
        end
    end
        
end
 
 
function val = lagrange_interp(xi,yi,target)
n = length(xi);
val = 0;
L = lagrange_basis(xi, target);
    for i = 1:n
        val = val + yi(i)*L(i);
    end
end
 
function L = lagrange_basis(xi, x)
n = length(xi);
L = ones(n,1);
    for i = 1:n
        for j = 1:n
            if i ~= j
            L(i) = L(i) * ((x - xi(j))/(xi(i) - xi(j))) ;
            end
        end
    end
end
