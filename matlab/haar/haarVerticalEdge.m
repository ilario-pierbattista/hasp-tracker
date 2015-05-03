function value = haarVerticalEdge(ii, x1, y1, x2, y2)
% haar edge verticale
sx = x2 - x1;
sy = y2 - y1;
if mod(sx,2) ~= 0
    error('myfuns:haarVerticalEdge:badArgument',...
    'la larghezza della finestra deve essere un numero pari di pixel');
end
middle = x1 + sx/2 - 1;
area = sx * sy;
%    x1  mid   x2
% y1 ***********
%    *    *    *
%    *    *    *
% y2 ***********

left = ii(y2, middle) + ii(y1, x1) - ii(y1, middle) - ii(y2, x1);
right = ii(y2,x2) + ii(y1,middle+1) - ii(y1,x2) - ii(y2,middle+1);
value = (left - right)/area;
