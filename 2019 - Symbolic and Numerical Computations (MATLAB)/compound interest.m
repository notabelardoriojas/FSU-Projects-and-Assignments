% Abelardo Riojas FSUID: ar18aa
% ISC 3133 Dr. Lemmon Fall 2019
% Lab 3 

% Part A: Compound Interest
n = 1:10;
a = compoundInterest(1000,.05,n);
plot(n,a)
xlabel('n')
ylabel('amount')
p = 1000;
b = compoundInterest(p,.05, 1:ceil(72/5));
fprintf('Using the rule of 72 double of %4.f is near %4.f\n', p,b(end));

% Part B: 
g = sumCompoundInterest(1000,.05,10);

fprintf('Gain: %.2f\n', g)

% Part C:
syms d n
eqn = 100000 * ((1+.05)^10) == symsum(d * ((1+.05)^(10-n)),n,1,30);
fprintf('The annual payment, D is %.2f\n', double(solve(eqn,d)))

% Functions
function a = compoundInterest(p,i,n)
   a = p * (1 + i).^n;
end

function g = sumCompoundInterest(d,i,T)
gain = [];
    for x = 1:T
        g = d * (1 + i)^(T-x);
        gain(end+1) = g;
    end
    g = sum(gain); 
end