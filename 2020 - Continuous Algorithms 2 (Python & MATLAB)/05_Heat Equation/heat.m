%Abelardo Riojascl
%ISC 4232
%Lab 5 Prof Quaife Fall 2020


%convergence study
error = zeros(1,8);
timesteps = zeros(1,8);
for n = 2:9
    N = 2^n;
    [U,x_ext,y_ext] = Screened_Poisson_2D(2, N, @f, @gl, @gr, @gd, @gu);
    h = 1/(N+1);
    timesteps(n-1) = h;
    
    [y,x] = meshgrid(0:h:1,0:h:1);
    
    U_exact = exact_sol(x,y);
    
    %adding boundary conditions to exact solution
    %left points
    U_exact(1,:) = gl(y_ext(1,:));

    %down points
    U_exact(:,1) = gd(x_ext(:,1));

    %right points
    U_exact(end,:) = gr(y_ext(end,:));

    %up points
    U_exact(:,end) = gu(x_ext(:,end));
    
    errorV = U-U_exact;
    
    %double sum since we're in R2
    error(n-1) = sqrt(sum(sum(errorV.^2)))/N;
    
end
figure
loglog(timesteps,error);
title('Error vs timestep size')
xlabel('timestep size')
ylabel('L2 error')
hold on
loglog(timesteps,.01*timesteps);
legend('error','10^-2')

[x,y,time,U] = Heat_Equation_2D(.1,.01,100,9,@u0);

times = [0 .2 .4 .6 .8 1];
figure
for i = 1:6
    subplot(2,3,i);
    ind = find(time==times(i));
    surf(U(:,:,ind));
    zlim([0 1]);
    title(sprintf('T = %f',times(i)));
end
sgtitle('Approximated U at t = [0 .2 .4 .6 .8 1]');







function[x,y,time,U] = Heat_Equation_2D(D,dt,M,N,u0)
h = 1/(N+1);
U = zeros(N+2,N+2,M);
%time vector
time = 0:dt:dt*M;

lambda = 1/(D*dt);
[y,x] = meshgrid(0:h:1,0:h:1);
[y_int,x_int] = meshgrid(h:h:1-h,h:h:1-h);
%making the first solution of U with u0

U(2:end-1,2:end-1,1) = u0(x_int,y_int);
%adding boundary conditions
U(1,:,1) = zeros(1,N+2);
U(:,1,1) = zeros(N+2,1);
U(end,:,1) = zeros(1,N+2);
U(:,end,1) = zeros(N+2,1);



%now that we have the first solution we can iterate
%we can reuse the gl funciton as our boundary condition from problem 1
%since it's just a zero vector
for i = 2:M+1
    U(:,:,i) = Screened_Poisson_2D(lambda, N, lambda.*U(:,:,i-1), @gl, @gl, @gl, @gl);
end
end



function val = u0(x,y)
val = sin(pi*x)*cos(pi*y);
end



function [U,x_ext,y_ext] = Screened_Poisson_2D(lambda, N, f, gl, gr, gd, gu)
h = 1/(N+1);

I = speye(N,N);
e = ones(N,1); %e vector makes this very nice
B = [1*e -2*e 1*e]; %centered difference
S = spdiags(B,-1:1,N,N);
 
%kron routines to make the A matrix
A = (lambda*kron(I,I));
A = A - ((1/(h^2)).* (kron(I,S)+kron(S,I)));




[y,x] = meshgrid(h:h:1-h,h:h:1-h);

%check here to see if we need to make f or if it's given to us 
if isa(f,'function_handle') == 1
    f_interior = f(x,y);
else
    f_interior = f(2:end-1,2:end-1);
end

%adding modifications to f_interior


f_interior(1,:) = f_interior(1,:) + ((1/h^2).*gl(y(1,:)));
f_interior(end,:) = f_interior(end,:) + ((1/h^2).*gr(y(end,:)));
f_interior(:,1) = f_interior(:,1) + ((1/h^2).*gd(x(:,1)));
f_interior(:,end) = f_interior(:,end) + ((1/h^2).*gu(x(:,end)));


f_interior = f_interior(:);

U_interior = A\f_interior; %solving with backslash operator


U_interior = reshape(U_interior,N,N); %reshaping here makes adding boundary condtions easy

%making the exterior points

[y_ext,x_ext] = meshgrid(0:h:1,0:h:1); %mesh grid with exterior points


U = zeros(N+2,N+2); %blank U matrix

%left points
U(1,:) = gl(y_ext(1,:));

%down points
U(:,1) = gd(x_ext(:,1));

%right points
U(end,:) = gr(y_ext(end,:));

%up points
U(:,end) = gu(x_ext(:,end));

%adding the boundary conditions and the interior points together
U(2:end-1,2:end-1) = U_interior;


end

%functions for the rhs of the possion eqn, exact solution, and boundary
%conditions
function val = f(x,y)
val = (2 + (2*pi*pi)).*sin(pi*x).*cos(pi*y);
end

function val = exact_sol(x,y)
val = sin(pi*x).*cos(pi*y);
end

function val = gl(y)
val = y.*0;
end

function val = gr(y)
val = y.*0;
end

function val = gd(x)
val = sin(pi*x);
end

function val = gu(x)
val = -sin(pi*x);
end
