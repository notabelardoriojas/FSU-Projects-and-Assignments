% Abelardo Riojas FSUID: ar18aa
% ISC 3133 Dr. Lemmon Fall 2019
% Lab 2 Newtons Method

[root, iter] = squareroot(100,10000)

function valx = f(x,a)
    valx = x*x - a;
end

function valx = f_prime(x)
    valx = 2*x;
end

function [x, iter] = squareroot(a, xguess)
    iter = 0;
    x = xguess - (f(xguess,a)/f_prime(xguess));
    xguess = x;
    while (abs(f(xguess,a)) >= .0001)
        x = xguess - (f(xguess,a)/f_prime(xguess));
        xguess = x;
        iter = iter +1;
    end    
end