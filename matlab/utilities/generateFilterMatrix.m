function filter = generateFilterMatrix(colDim, rowDim, colorDepth, weights)
% Genera la matrice di filtro per il le immagini raw

if nargin > 4
    error('myfuns:generateFilterMatrix:tooManyArguments')
end

if mod(colorDepth, 8) ~= 0
    error('myfuns:generateFilterMatrix:badArgument',...
    'Sembra che colorDepth abbia un valore strano. Dovrebbe essere un ',...
    'multiplo di 8 (bit)')
end

bpp = colorDepth / 8;
if nargin == 4
    if length(weights) ~= bpp
        error('myfuns:generateFilterMatrix:badArgument',...
        'La lunghezza di weights deve essere uguale al numero di byte ',...
        'utilizzati per la rappresentazione del pixel')
    end
else
    weights = zeros(bpp, 1);
    for i = [1:bpp]
        weights(i) = 2^(8*(bpp - i));
    end
end

filter = zeros(colDim*bpp, colDim);
for i = [0 : colDim - 1]
    for j = [1 : bpp]
        filter(i*bpp + j, i + 1) = weights(j);
    end
end
