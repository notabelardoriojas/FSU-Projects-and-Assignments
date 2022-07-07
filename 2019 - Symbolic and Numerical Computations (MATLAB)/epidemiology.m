%Abelardo Riojas
%ISC 3222 Lab 4
%Dr. Lemmon, Fall 2019

%Questions 1 and 2
[t,xa] = ode45(ODE(.5,.1),[0 50],[0.99 .01 0.00]);

figure(1)
subplot(2,1,1);
plot(t,xa)
title('\beta = .5, v = .1')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')

[t,xb] = ode45(ODE(.1,.5),[0 50],[0.99 .01 0.00]);

subplot(2,1,2); 
plot(t,xb)
title('\beta = .1, v = .5')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')

%Question 3
%In the first example with a moderate contact rate and low recovery rate, 
%the number of susceptible individuals decreases steadily as the number of 
%infections flares up. Eventually the recovery rate starts to decrease the 
%number of infections, decreasing the number of susceptible individuals 
%further, along with the infected and increasing the number of 
%recovered/dead individuals.

%In the second example with the low contact rate and moderate recovery 
%rate, the number of susceptible individuals remains relatively high. 
%The number of infected individuals has no effect on the general population, 
%and those that do have the disease tend to recover quickly.

%Question 4
beta = [.1 .333 .5 .75 .99];
v = [0 .99 .5 .333 .01];
s0 = [.99, .1, .5, .333, .75];
n = 1;
for x = 1:5
    if r0(beta(x),v(x),n) >= n/s0(x)
        fprintf('beta = %.2f, v = %.2f, s(0) = %.2f \n EPIDEMIC\n', beta(x), v(x), s0(x))
    else
        fprintf('beta = %.2f, v = %.2f, s(0) = %.2f \n DIES OUT\n', beta(x), v(x), s0(x))
    end
end

%Question 5
figure('Renderer', 'painters', 'Position', [10 10 900 600])
[t,xa] = ode45(ODE(.5,.1),[0 50],[0.5 .01 0.00]);
subplot(2,3,1);
plot(t,xa)
title('Control \beta = .5, v = .1')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')
ylim([0 1])
%Sequestration of infected animals decreases the contact rate
[t,x1] = ode45(ODE(.1,.1),[0 50],[0.5 .01 0.00]);
subplot(2,3,2);
plot(t,x1)
title('Sequestration of infected animals \beta = .1, v = .1')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')
ylim([0 1])
%Uptick in use of hand santizers moderately decreases the contact rate
[t,x2] = ode45(ODE(.4,.1),[0 50],[0.5 .01 0.00]);
subplot(2,3,3);
plot(t,x2)
title('Uptick in use of hand santizers \beta = .4, v = .1')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')
ylim([0 1])
%Development of new therapy increases recovery rate by a factor of 4
[t,x3] = ode45(ODE(.5,.4),[0 50],[0.5 .01 0.00]);
subplot(2,3,4);
plot(t,x3)
title('Development of new theraphy \beta = .5 v = .4')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')
ylim([0 1])
%Urbanization increases contact rate
[t,x4] = ode45(ODE(.75,.1),[0 50],[0.5 .01 0.00]);
subplot(2,3,5);
plot(t,x4)
title('Urbanization \beta = .75 v = .1')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')
ylim([0 1])
%Spread of anti-vaccination movement increases s(0)
[t,x5] = ode45(ODE(.75,.1),[0 50],[0.75 .01 0.00]);
subplot(2,3,6);
plot(t,x5)
title('Spread of anti-vaccination movement \beta = .5 v = .1')
xlabel('t'), ylabel('s, i, r')
legend('s(t)','i(t)','r(t)')
ylim([0 1])

    
    
%Functions
function f = ODE(beta, v)
    f = @(t,x) [(-1*beta*x(2)*x(1));(beta*x(2)*x(1))-(v*x(2));v*x(2)];
end

function R0 = r0(beta,v,n)
    R0 = beta/(v*n);
end
