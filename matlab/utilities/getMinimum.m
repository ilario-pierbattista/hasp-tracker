function [minimum, x, y] = getMinimum(minima, mx, my)
% Ricava il minimo assoluto dai minimi locali
minima(minima == 0) = NaN;
[minimum I] = min(minima(:));
[i,j] = ind2sub(size(minima), I);
x = mx(i,j);
y = my(i,j);
