function value = haarVerticalLinear(ii, x1, y1, x2, y2)
% haar edge verticale
sx = x2 - x1;
sy = y2 - y1;
if mod(sx,4) ~= 0
    error('myfuns:haarVerticalEdge:badArgument',...
    'la larghezza della finestra deve essere un numero di pixel divisibile per 4');
end
m1 = x1 + sx/4 - 1;
m2 = x1 + sx*3/4 - 1;
area = sx * sy;
%    x1 m1   m2  x2
% y1 ************
%    *  *    *  *
%    *  *    *  *
% y2 ************

left = ii(y2, m1) + ii(y1, x1) - ii(y1, m1) - ii(y2, x1);
center = ii(y1, m2) + ii(y1,m1+1) - ii(y1, m2) - ii(y2, m1+1);
right = ii(y2, x2) + ii(y1, m2+1) - ii(y1, x2) - ii(y2, m2+1);
value = (left - center + right)/area;
