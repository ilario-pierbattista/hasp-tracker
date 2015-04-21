function data = readImageData(fp, colDim, rowDim, colorDepth, filterMatrix)
% Legge un'immagine come array di double

if nargin > 5
    error('myfuns:readImageData:tooManyArguments')
elseif nargin == 4
    filterMatrix = generateFilterMatrix(colDim, rowDim, colorDepth);
end

% se fp non è un file descriptor, potrebbe essere una path
% tento quindi di aprire il file in modalità binaria
if ~isnumeric(fp)
    fp = fopen(fp, 'r');
end

% Controllo sul valore di colorDepth
if colorDepth ~= 16 && colorDepth ~= 24 && colorDepth ~= 8 && colorDepth ~= 32
    error('myfuns:readImageData:strangeColorDepth',...
        strcat('colorDepth = ',num2str(colorDepth),' non è un valore valido.'))
end

bpp = colorDepth / 8;   % Bytes Per Pixel
data = zeros(rowDim, colDim);

cursore = 1;
i = 1; j = 1;
stream = transpose(fread(fp));

% Controllo dei file immagine
if length(stream) ~= bpp * colDim * rowDim
    error('myfuns:readImageData:dimentionMismatch',...
        strcat('Le dimensioni date ',num2str(colDim),'x',num2str(rowDim),...
        ' e ColorDepth = ',num2str(colorDepth),' non sono corretti oppure',...
        ' il file è corrotto'))
end

% Conversione da array a matrice 
raw = vec2mat(stream, colDim*bpp);
data = raw*filterMatrix;
