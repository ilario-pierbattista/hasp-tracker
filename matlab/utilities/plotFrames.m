function plotFrame(path, colDim, rowDim, frameRate)
% Plotting dei frame di profondità
% Controllo argomenti opzionali
if length(nargin) < 3
    error('myfuns:plotFrame:tooLessParameters',...
        'path, colDim e rowDim sono parametri necessari')
elseif length(nargin) == 3
    frameRate = 0
end

if size(path, 1) == 1
    % si tratta di un singolo frame
else
    % si tratta di una serie di frame
end
