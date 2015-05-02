function data = readImageData(fp, colDim, rowDim, colorDepth)
% Legge un'immagine come array di double

if nargin > 4
    error('myfuns:readImageData:tooManyArguments')
end

% se fp non è un file descriptor, potrebbe essere una path
% tento quindi di aprire il file in modalità binaria
if ~isnumeric(fp)
    fp = fopen(fp, 'r');
end

% Impostazione del formato
formato = '';
switch colorDepth
    case 16
        formato = 'uint16';
    case 24
        % Potrebbe generare errori. Oppure potrebbe essere del tutto
        % inutile.
        formato = 'ubit24'; 
    case 8
        formato = 'uint8';
    case 32
        formato = 'uint32';
    otherwise
        error('myfuns:readImageData:strangeColorDepth',...
        strcat('colorDepth = ',num2str(colorDepth),' non è un valore valido.'))
end

stream = fread(fp, formato);

% Controllo dei file immagine
if length(stream) ~= colDim * rowDim
    error('myfuns:readImageData:dimentionMismatch',...
        strcat('Le dimensioni date ',num2str(colDim),'x',num2str(rowDim),...
        ' e ColorDepth = ',num2str(colorDepth),' non sono corretti oppure',...
        ' il file è corrotto'))
end

% Conversione da array a matrice 
data = vec2mat(stream, colDim);
