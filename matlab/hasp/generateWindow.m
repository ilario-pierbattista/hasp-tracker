function [x,y] = generateWindow(x0, y0, subwSize)
% Genera le coordinate delle sottofinestre da usare per il modello
% a partire dal punto centrale
[x,y] = meshgrid(x0-2*subwSize : subwSize : x0+2*subwSize,...
            y0-2*subwSize: subwSize : y0+2*subwSize);
x = [nan(5,1) x nan(5,1)];
y = [nan(5,1) y nan(5,1)];
x(2:4,1) = x(1,2) - subwSize/2;
x(2:4,7) = x(1,6) + subwSize/2;
y(2:4,1) = y(2:4,2);
y(2:4,7) = y(2:4,6);
