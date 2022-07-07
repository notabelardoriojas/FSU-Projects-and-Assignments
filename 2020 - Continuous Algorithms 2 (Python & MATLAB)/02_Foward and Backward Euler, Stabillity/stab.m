%Abelardo Riojas
%ISC 4334 Lab 2 Stability
%Prof. Quaife, Fall 2020

stability_plot(@MRamp);


dts = [.1 .3]; %different timesteps for comparions
for i = 1:length(dts) %loops through timesteps
    %[T,Y,err] = Forward_Euler(1,0,10,dts(i),@ivp); %forward euler doesn't
    %need partial
    [T,Y,err] = Backward_Euler(1,0,10,dts(i),@ivp,@ivpp);  %backward euler needs partial
    figure
    plot(T,Y);
    title(sprintf('Backward Euler Approximation with \\Delta T = %f',dts(i)));
    hold on
    fplot(@(x) exp(-8*x),[0 10]); %plotting exact solution
    legend('Approximate solution','Exact solution')
end

function [T,Y,err] = Backward_Euler(y0,t0,T,dt,fyt,Fdy) %taken from Lab 1
T = t0:dt:T; %time discretization
n = length(T);
Y = zeros(1,n);
Y(1) = y0; %initial condition
for i = 2:n
    Y(i) = Backward_Euler_Step(Y(i-1),T(i),dt,fyt,Fdy); %uses newtons method to solve implicit scheme
end
    err = abs(Y(end) - exp((-T(end)^2)/2));
end

function Ynext = Backward_Euler_Step(Yn,tn,dt,fyt,Fdy)
maxiter = 1000;
tol = 1e-6;
G = @(y) y-Yn-dt*fyt(y,tn);
Gdy = @(y) 1-dt*Fdy(y,tn);
Ynext = newtons(maxiter,G,Gdy,tol,Yn);
end


function [T,Y,err] = Forward_Euler(y0,t0,T,dt,fyt) %taken from Lab_1
T = t0:dt:T; %time discretization
n = length(T);
Y = zeros(1,n);
Y(1) = y0; %initial condition
yn = y0;
for i = 2:n
    Y(i) = yn + dt*fyt(yn,T(i)); %apply method
    yn = Y(i);
end
    err = abs(Y(end) - exp((-T(end)^2)/2));
end

function val = ivp(yn,tn) %test ivp with lambda = -8
val = -8*yn;
end

function val = ivpp(yn,tn) %partial of test ivp with respect to y
val = -8;
end
function amp_factor = FEamp(z) % amplification factor of FE (given)
amp_factor =  1+z;
end

function amp_factor = BEamp(z) % amplification factor of BE (given)
amp_factor = 1/(1-z);
end

function amp_factor = MRamp(z) % amp factor of Midpoint rule (derived)
amp_factor = 1 + z + (z^2)/2;
end


function fig = stability_plot(amp_factor) 
mesh = -5:.01:5; %making a mesh
[X,Y] = meshgrid(mesh);
stability = uint8(zeros(length(mesh),length(mesh),3)); %making stability image
for i = 1:length(mesh)
    for j = 1:length(mesh)
        z = X(i,j) + 1i*Y(i,j); %real and imaginary parts of z
        if abs(amp_factor(z)) < 1
            stability(i,j,1) = 255; % red
        else
            stability(i,j,3) = 255; % blue
        end
    end
end
fig = imshow(stability);
title('Region of stability for Midpoint Rule')
axis on;
%custom tick marks
xtnew = linspace(1, 1000, 11);                              % New 'XTick' Values
xtlbl = linspace(-5, 5, numel(xtnew));                  % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) 
ytnew = linspace(1, 1000, 11);                              % New 'XTick' Values
ytlbl = linspace(-5, 5, numel(xtnew));                  % New 'XTickLabel' Vector
set(gca, 'YTick',ytnew, 'YTickLabel',ytlbl) 
end

function [x1, iter] = newtons(maxiter,f,fp,tol,x0) % from lab 1, basic newtons method
    iter = 0;
    while iter < maxiter
        x1 = x0 - (f(x0)/fp(x0));
        iter = iter + 1;
        if abs(x1 - x0) <= tol % you don't expect me to put comments on this too, right?
            break;
        else
            x0 = x1;
        end
    end
        
end