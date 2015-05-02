function value = haarHorizontalLinear(ii, x1, y1, x2, y2)
% haar edge verticale
sx = x2 - x1;
sy = y2 - y1;
if mod(sy,4) ~= 0
    error('myfuns:haarVerticalEdge:badArgument',...
    'l''altezza della finestra deve essere un numero di pixel divisibile per 4');
end
m1 = y1 + sy/4 - 1;
m2 = y1 + sy*3/4 - 1;
area = sx * sy;
%    x1         x2
% y1 ************
%    *          *
% m1 ************
%    *          *
%    *          *
%    *          *
% m2 ************
%    *          *
% y2 ************

top = ii(m1, x2) + ii(y1, x1) - ii(y1, x2) - ii(m1, x2);
center = ii(m2, x2) + ii(m1+1,x1) - ii(m1+1,x2) - ii(m2,x1);
bottom = ii(y2,x2) + ii(m2+1,x1) - ii(m2+1,x2) - ii(y2,x1);
value = (top - center + bottom)/area;
