function value = haarHorizontalEdge(ii, x1, y1, x2, y2)
% haar edge orizzontale
sx = x2 - x1;
sy = y2 - y1;
if mod(sy,2) ~= 0
    error('myfuns:haarVerticalEdge:badArgument',...
    'la larghezza della finestra deve essere un numero pari di pixel');
end
middle = y1 + sy/2 - 1;
area = sx * sy;
%    x1        x2
% y1 ***********
%    *         *
% md ***********
%    *         *
% y2 ***********

top = ii(middle, x2) + ii(y1, x1) - ii(y1, x2) - ii(middle, x1);
bottom = ii(y2,x2) + ii(middle+1, x1) - ii(y2,x1) - ii(middle+1,x2);
value = (bottom - top)/area;
