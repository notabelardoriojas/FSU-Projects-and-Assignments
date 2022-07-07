syms v(t) g c m
% 1: Use Matlab?s symskeyword along with the diff
% and dsolvefunction to obtain this analytical solution
eqn = diff(v,t) == g - c/m * v^2;
cond = v(0) == 0;
S = dsolve(eqn,cond);
pretty(S)

S = subs(S, g, 9.8);
S = subs(S, c, .00005);
S = subs(S, m, .0025);

% Verify the solution by using a numerical method, 
% like ode45, to approximate the solution. 
tspan = [0 10];
v0 = 0;
[tn,vn] = ode45(@(t,vn) 9.8 - .00005/.0025 *vn^2, tspan, v0)

% Plot the analytical solution and numerical solution to 
% find the ?terminal? velocity for the given values of m, g, and c.
hold on
fplot(S,tspan, '-*');
plot(tn,vn, '-o');
legend('Symbolic', 'Numerical')
hold off

% Can you write a general analytical expression for terminal velocity?
% Yes, it's the limit as t goes to infinity of 
% (g^(1/2)*m^(1/2)*tanh((c^(1/2)*g^(1/2)*t)/m^(1/2)))/c^(1/2)


% Find an analytical solution to this integral using the symsand intMatlab functions.
p = int(S);

% Assuming the Empire State Building is 381 meters tall 
% what would the velocity of the penny be as it hits the ground? 
% What would the velocity be if it fell from 10,000 meters?
empireheight= 381;

time = solve(p == empireheight, t);

time = double(time(2));

empVel = double(subs(S, t, time))

tenkHeight = 10000;

time = solve(p == tenkHeight, t);

time = double(time(2));

tenkVel = double(subs(S, t, time))

% Write a summary interpreting your results. 
% Search the web if you are unsure of your results 

% Summary: Once the penny has dropped a sufficient height, it's velocity
% will increase no further. This is because the penny reaches "terminal"
% velocity: where the gravitational force and the force of air resistance have 
% reached equilibrium.
