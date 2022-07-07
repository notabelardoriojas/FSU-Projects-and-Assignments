%Abelardo Riojas
%ISC 4232 Lab 4

N = 64; %global variables to make things easier
a = 0;
b = 2*pi;
ua = 5;
ub = 8*(pi^3)+5;

U1 = Possion_Solver("dense",@func,0,2*pi,5,8*(pi^3)+5,64)';
U2 = Possion_Solver("sparse",@func,0,2*pi,5,8*(pi^3)+5,64)';
U3 = Possion_Solver("thomas",@func,0,2*pi,5,8*(pi^3)+5,64)';

h = (b-a)/(N+1);

U1 = [ua U1 ub]; %appending the boundary conditions to the approximate solution for graphing
U2 = [ua U2 ub];
U3 = [ua U3 ub];
x = 0:h:2*pi;
exactU = exact_sol(x);


subplot(1,3,1); %subplots because subplots are fancy and nice!
plot(x,exactU,'LineWidth',4);
hold on
plot(x,U1,'LineWidth',2);
legend('exact','U1');

subplot(1,3,2);
plot(x,exactU,'LineWidth',4);
hold on
plot(x,U2,'LineWidth',2);
legend('exact','U2');

subplot(1,3,3);
plot(x,exactU,'LineWidth',4);
hold on
plot(x,U3,'LineWidth',2);
legend('exact','U3');



%convergence study
error2 = zeros(1,6);
errorinf = zeros(1,6);



for n = 2:7
    N = 2^n; 
    U2 = Possion_Solver("sparse",@func,0,2*pi,5,8*(pi^3)+5,N)';
    
    h = (b-a)/(N+1);
    x = 0:h:2*pi;
    exactU = exact_sol(x);
    exactU(1) = [];
    exactU(end) = [];
    
    errorV = U2-exactU;
    
    
    error2(n-1) = sqrt(sum(errorV.^2))/sqrt(N); %l2 norm
    errorinf(n-1) = max(abs(errorV)); %linf norm
    
end

figure
N = 2.^(2:7);
loglog(N,error2);
hold on
loglog(N,errorinf);
legend('L2 error','Linf error')

%CPU timing

sparseTimes = zeros(1,12);
denseTimes = zeros(1,12);
thomasTimes = zeros(1,12);
for i = 4:15
    N = 2^i;
    tic;
    U1 = Possion_Solver("dense",@func,0,2*pi,5,8*(pi^3)+5,N)';
    
    denseTimes(i-3) = toc;
    tic;
    U2 = Possion_Solver("sparse",@func,0,2*pi,5,8*(pi^3)+5,N)';
    toc;
    sparseTimes(i-3) = toc;
    tic
    U3 = Possion_Solver("thomas",@func,0,2*pi,5,8*(pi^3)+5,N)';
    toc;
    thomasTimes(i-3) = toc;
end

%log log plot for cpu times
figure
N = 2.^(4:15);
loglog(N,denseTimes);
hold on
loglog(N,sparseTimes);
hold on
loglog(N,thomasTimes);








function U = Possion_Solver(string,func,a,b,ua,ub,N)
h = (b-a)/(N+1);
x = a:h:b;

x(1) = []; %have to get rid of these since the methods only approximate x1 to xn
x(end) = [];
rhs = zeros(1,N);
rhs(1) = (1/(h^2))*ua;
rhs(end) = (1/(h^2))*ub;
f = func(x) + rhs;
f = f';
    if string == "dense"
        U = Finite_Difference_Dense(a,b,N)\f; %backlash operator
    elseif string == "sparse"
        U = Finite_Difference_Sparse(a,b,N)\f; %backlash operator
    elseif string == "thomas"
        e = ones(N,1); %have to make the a b c vectors here
        at = -1/(h^2)*e; 
        bt = 2/(h^2)*e;
        ct = -1/(h^2)*e;
        U = Thomas_Solver(at,bt,ct,f);
    else
        output('Not a valid string')
    end
end




function A = Finite_Difference_Dense(a,b,N)
A = zeros(N,N);
h = (b-a)/(N+1);
for i = 1:N % just some simple for looping, following the steps of the lab
    for j = 1:N
        if i == j+1
            A(i,j) = -1/(h^2);
        elseif i == j-1
            A(i,j) = -1/(h^2);
        elseif  i == j
            A(i,j) = 2/(h^2);
        end
    end
end
end

function A = Finite_Difference_Sparse(a,b,N)
h = (b-a)/(N+1);
e = ones(N,1); %e vector makes this very nice

B = [-1/(h^2)*e 2/(h^2)*e -1/(h^2)*e]; %centered difference has -1 2 1 pattern, with 1/h2 being the denominator term

A = spdiags(B,-1:1,N,N); %using quaife's shortcut
end


function x = Thomas_Solver(a,b,c,d) %for this part, you just need to look at the lab report 
N = length(d);
a(1) = 0;
c(end) = 0;
x = zeros(N,1);
cp = zeros(1,N-1);
dp = zeros(1,N);
    for i = 1:N-1
        if i == 1
            cp(i) = c(i)/b(i);
        else
            cp(i) = c(i)/(b(i) - a(i)*cp(i-1));    
        end
    end
    for i = 1:N
        if i == 1
            dp(i) = d(i)/b(i);
        else
            dp(i) = (d(i) - (a(i)*dp(i-1)))/(b(i) - (a(i)*cp(i-1)));
        end
    end
    x(end) = dp(end);
    for i = N-1:-1:1 %N-1 to 1, using the last value we made
        x(i) = dp(i) - cp(i)*x(i+1);
    end
end

function val = func(x) % second derivative of the exact solution
val = -6*x - sin(x);
end

function val = exact_sol(x) %exact solution
val = x.^3 - sin(x) + 5;
end
