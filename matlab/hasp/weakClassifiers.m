function [h, v] = weakClassifiers(ii, Wx, Wy)
% La finestra generata è della forma:
% (x0,y0)
% *    *----*----*----*----*
%      | 2  | 6  | 10 | 14 |
% *----*----*----*----*----*----*
% | 0  | 3  | 7  | 11 | 15 | 18 |
% *----*----*----*----*----*----*
% | 1  | 4  | 8  | 12 | 16 | 19 |
% *----*----*----*----*----*----*
%      | 5  | 9  | 13 | 17 |    
%      *----*----*----*----*

% 2,6,10,14 / - 3,4,11,15,4,8,12,16 / 5,9,13,17
v = haarHorizontalLinear(ii, Wx(1,2), Wy(1,2), Wx(5,6), Wy(5,6));
h = v > 0;

% 3,4 / - 7,11,8,12 / 15,16
v = [v haarVerticalLinear(ii, Wx(2,2), Wy(2,2), Wx(4,6), Wy(4,6))];
h = [h v(end) > 0];

% 0,1 / - 3,4
v = [v haarVerticalEdge(ii, Wx(2,1), Wy(2,1), Wx(4,3), Wy(4,3))];
h = [h v(end) > 0];

% 18,19 / - 15,16
v = [v haarVerticalEdge(ii, Wx(2,5), Wy(2,5), Wx(4,7), Wy(4,7))];
h = [h v(end) < 0];

% 3,7,11,15 / - 2,6,10,14
v = [v haarHorizontalEdge(ii, Wx(1,2), Wy(1,2), Wx(3,6), Wy(3,6))];
h = [h v(end) < 0];

% 5,9,13,17 / - 4,8,12,16
v = [v haarHorizontalEdge(ii, Wx(3,1), Wy(3,1), Wx(5,6), Wy(5,6))];
h = [h v(end) > 0];

% 3,4 / - 7,8
v = [v haarVerticalEdge(ii, Wx(2,2), Wy(2,2), Wx(4,4), Wy(4,4))];
h = [h v(end) > 0];

% 11,12 / - 15,16
v = [v haarVerticalEdge(ii, Wx(2,4), Wy(2,4), Wx(4,6), Wy(4,6))];
h = [h v(end) < 0];
