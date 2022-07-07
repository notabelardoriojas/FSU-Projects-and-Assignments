%Abelardo Riojas
%ISC 4232 Lab 3
%Prof. Quaife Fall 2020
dts1 = [1/4 1/8 1/16 1/32 1/64];
errs1 = zeros(1,5);

dts2 = [1/16 1/32 1/64 1/128 1/256];
M = 2:5;
errs2 = zeros(4,5);
for m = M(1):M(end)
    for i = 1:5
        [Y,T,rel,err] = AdamsBashforth(@ivp,-1,1,dts2(i),m);
        rel
        m
        1/dts2(i)
        errs2(m-1,i) = err;
    end
end
for i = 1:4
    loglog(dts2,errs2(i,:))
    legend('m=2','m=3','m=4','m=5')
    hold on
end

for i = 1:5
    [Y,T,rel,err] = RK4(@ivp,-1,1,dts1(i));
    rel
    errs1(i) = err;
end

stability_plot(@RK4amp);
%loglog(dts1,errs1);

[Y,T] = AdamsBashforth(@ivp,-1,1,1/32,5);


function [Y,T,RelErr,err] = AdamsBashforth(fyt,y0,Tf,dt,m)
T = 0:dt:Tf; %time domain
n = length(T);
Y = zeros(1,n);
Y(1) = y0; %initial condition
%calculate m-1 timesteps
Y(1:m) = RK4(fyt, y0, T(m),dt);
b = [1 0 0 0 0;
    3/2 -1/2 0 0 0;
    23/12 -4/3 5/12  0 0;
    55/24 -59/24 37/24 -3/8 0;
    1901/720 -1387/360 109/30 -637/360 251/720];
    for i = m+1:n
        sum = 0;
        for j = 1:m
            sum = sum + b(m,j)*fyt(Y(i-j),T(i-j));
        end
        Y(i) = Y(i-1) + dt*sum;
    end
    RelErr = abs(Y(end) + exp(1 - cos(T(end))))/-exp(1-cos(T(end)));
    err = abs(Y(end) + exp(1-cos(T(end))));
end


function [Y,T,RelErr,err] = RK4(fyt, y0,Tf,dt)
T = 0:dt:Tf;
n = length(T);
Y = zeros(1,n);
Y(1) = y0; %initial condition
    for i = 2:n
        k1 = dt*fyt(Y(i-1),T(i-1));
        k2 = dt*fyt(Y(i-1) + .5*k1, T(i-1) + (.5*dt));
        k3 = dt*fyt(Y(i-1) + 0*k1 + .5*k2, T(i-1) + (.5*dt)); 
        k4 = dt*fyt(Y(i-1) + 0*k1 + 0*k2 + k3, T(i-1) + (1*dt)); 
        Y(i) = Y(i-1) + (1/6)*k1 + (1/3)*k2 + (1/3)*k3 + (1/6)*k4;
    end
     RelErr = abs(Y(end) + exp(1 - cos(T(end))))/-exp(1-cos(T(end)));
     err = abs(Y(end) + exp(1-cos(T(end))));
end

function val = ivp(yn,tn)
val = yn * sin(tn);
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
title('Region of stability for RK4 Rule')
axis on;
%custom tick marks
xtnew = linspace(1, 1000, 11);                              % New 'XTick' Values
xtlbl = linspace(-5, 5, numel(xtnew));                  % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) 
ytnew = linspace(1, 1000, 11);                              % New 'XTick' Values
ytlbl = linspace(-5, 5, numel(xtnew));                  % New 'XTickLabel' Vector
set(gca, 'YTick',ytnew, 'YTickLabel',ytlbl) 
end

function amp_factor = RK4amp(z)
amp_factor = (1 + z/6 + z/3 + (z^2)/6 + z/3 + (z^2)/6 + (z^3)/12 + z/6 + (z^2)/6 + (z^3)/12 + (z^4)/24);
end

