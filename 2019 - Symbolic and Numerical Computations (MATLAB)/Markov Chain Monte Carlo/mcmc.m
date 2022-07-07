xs1=textread('xs_deg1.txt','%f');
ys1=textread('ys_deg1.txt','%f');
xs2=textread('xs_deg2.txt','%f');
ys2=textread('ys_deg2.txt','%f');
xs3=textread('xs_deg3.txt','%f');
ys3=textread('ys_deg3.txt','%f');
xs4=textread('xs_deg4.txt','%f');
ys4=textread('ys_deg4.txt','%f');

figure(1)
subplot(2,2,1)
coefs1 = mcmcfit(xs1,ys1,[0 2], 10000);
a1 = mean(coefs1);
[likelydeg1, yEst1, diff1] = like(xs1, ys1, a1);
scatter(xs1, yEst1, 'red', 'filled')
hold on
scatter(xs1, ys1, 'blue', 'filled')
fplot(@(x) a1(1) + a1(2)*x)
title([num2str(a1(1),3), ' + ', num2str(a1(2),3), + 'x'])
titlestr = '';
c = numel(a1);
for i = 1:c
    titlestr = append(titlestr, num2str(a1(i),3));
    titlestr = append(titlestr, 'x^', num2str(i-1));
    if i ~= c
        titlestr = append(titlestr, ' + ');
    end
end
title(titlestr);

subplot(2,2,2)
coefs2 = mcmcfit(xs2,ys2,[0 1 1], 10000);
a2 = mean(coefs2);
[likelydeg2, yEst2, diff2] = like(xs2, ys2, a2);
scatter(xs2, yEst2, 'red', 'filled')
hold on
scatter(xs2, ys2, 'blue', 'filled')
fplot(@(x) a2(1) + a2(2)*x + a2(3)*x.^2)
titlestr = '';
c = numel(a2);
for i = 1:c
    titlestr = append(titlestr, num2str(a2(i),3));
    titlestr = append(titlestr, 'x^', num2str(i-1));
    if i ~= c
        titlestr = append(titlestr, ' + ');
    end
end
title(titlestr);

subplot(2,2,3)
coefs3 = mcmcfit(xs3,ys3,[0 1 1 2], 10000);
a3 = mean(coefs3);
[likelydeg3, yEst3, diff3] = like(xs3, ys3, a3);
scatter(xs3, yEst3, 'red', 'filled')
hold on
scatter(xs3, ys3, 'blue', 'filled')
fplot(@(x) a3(1) + a3(2)*x + a3(3)*x.^2 + a3(4)*x.^3)
titlestr = '';
c = numel(a3);
for i = 1:c
    titlestr = append(titlestr, num2str(a3(i),3));
    titlestr = append(titlestr, 'x^', num2str(i-1));
    if i ~= c
        titlestr = append(titlestr, ' + ');
    end
end
title(titlestr);

subplot(2,2,4)
coefs4 = mcmcfit(xs4,ys4,[0 3 2 1 -2], 10000);
a4 = mean(coefs4);
[likelydeg4, yEst4, diff4] = like(xs4, ys4, a4);
scatter(xs4, yEst4, 'red', 'filled')
hold on
scatter(xs4, ys4, 'blue', 'filled')
fplot(@(x) a4(1) + a4(2)*x + a4(3)*x.^2 + a4(4)*x.^3 + a4(5)*x.^4)
titlestr = '';
c = numel(a4);
for i = 1:c
    titlestr = append(titlestr, num2str(a4(i),3));
    titlestr = append(titlestr, 'x^', num2str(i-1));
    if i ~= c
        titlestr = append(titlestr, ' + ');
    end
end
title(titlestr);


% figure(2)
% histo(coefs1)
% figure(3)
% histo(coefs2)
% figure(4)
% histo(coefs3)
% figure(5)
% histo(coefs4)

disp(polyfit(xs1,ys1,1))
disp(flip(a1))
disp(polyfit(xs2,ys2,2))
disp(flip(a2))
disp(polyfit(xs3,ys3,3))
disp(flip(a3))
disp(polyfit(xs4,ys4,4))
disp(flip(a4))


function histo(coefs)
c = size(coefs,2);
    for j = 1:c
        subplot(1,c,j)
        histogram(coefs(:,j))
    end
end


function coefs = mcmcfit(x,y,guess,n)
    deg = numel(guess);
    coefs = zeros(n,deg);
    coef = guess;
    for i = 1:n
        [likeold,~,~] = like(x,y,coef); 
        change = 2*rand(1,deg) - 1;
        newcoef = coef + change;
        [likenew,~,~] = like(x,y,newcoef);
        if exp(likenew - likeold) > rand()
            coef = newcoef;
        end
        coefs(i,:) = coef(1,:);
    end
end

function [l, yEst, diff] = like(x,y,coef)
coef = flip(coef);
% c = numel(coef);
% yEst = zeros(numel(x,1));
% for i = 1:c
%     yEst = yEst + coef(i)*(x.^(i-1));
% end

yEst = polyval(coef, x);

diff = abs(y - yEst);

l = sum(log(normpdf(diff, 0, 1)));
end

