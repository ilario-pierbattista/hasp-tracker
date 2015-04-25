function ii = integralImage(data)
% Genera l'immagine integrale
ii = zeros(size(data));

% Inizializzazioni per aumentare l'efficienza
if min(size(data)) < 2
    error('myfuns:integralImage:badArgument',...
    'La matrice rappresentativa dell''immagine non dovrebbe essere un array')
end
ii(1,1) = data(1,1);
ii(1,2) = ii(1,1) + data(1,2);
ii(2,1) = ii(1,1) + data(2,1);

[rows, cols] = size(data);
for i = [2:rows]
    for j = [2:cols]
        ii(i, j) = data(i, j) + ii(i-1, j) + ii(i, j-1) - ii(i-1, j-1);
    end
end
