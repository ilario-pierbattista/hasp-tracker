function [x,y] = generateWindow(x0, y0, subwSize)
% Genera le coordinate delle sottofinestre da usare per il modello
% a partire dal punto centrale [OLD]
% [x,y] = meshgrid(x0-2*subwSize : subwSize : x0+2*subwSize,...
%            y0-2*subwSize: subwSize : y0+2*subwSize);
% x = [nan(5,1) x nan(5,1)];
% y = [nan(5,1) y nan(5,1)];
% x(2:4,1) = x(1,2) - subwSize/2;
% x(2:4,7) = x(1,6) + subwSize/2;
% y(2:4,1) = y(2:4,2);
% y(2:4,7) = y(2:4,6);

% Genera le coordinate delle sottofinestre da usare per il modello 
% a partire dal punto in alto a sinistra
%
% (x0,y0)
% *    *----*----*----*----*
%      |    |    |    |    |
% *----*----*----*----*----*----*
% |    |    |    |    |    |    |
% *----*----*----*----*----*----*
% |    |    |    |    |    |    |
% *----*----*----*----*----*----*
%      |    |    |    |    |    
%      *----*----*----*----*

% Se è un vettore riga, j è diverso da 1
[i, j] = size(subwSize);
if j ~= 1
    sx = subwSize(1);
    sy = subwSize(2);
else
    sx = subwSize;
    sy = subwSize;
end
[x,y] = meshgrid(x0 : sx : x0+sx*6, y0 : sy : y0+sy*4);

% Rimuovo gli angoli della finestra marcandoli con NaN
x(1,1) = NaN;   y(1,1) = NaN;
x(5,1) = NaN;   y(5,1) = NaN;
x(1,7) = NaN;   y(1,7) = NaN;
x(5,7) = NaN;   y(5,7) = NaN;
