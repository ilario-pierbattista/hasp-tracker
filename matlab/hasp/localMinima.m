function [minima, mx, my] = localMinima(data, meshSize)
% Calcola i minimi locali
[rows cols] = size(data);
[x, y] = meshgrid(1:meshSize-1:cols, 1:meshSize-1:rows);
[meshrows, meshcols] = size(x);

% Aggiunta di un'altra fascia alla griglia, nel caso in cui la griglia
% non copra tutta l'immagine
if mod(cols + 1, meshSize) ~= 0
    x = [x zeros(meshrows, 1)];
    y = [y zeros(meshrows, 1)];
    x(:,meshcols+1) = cols;
    y(:,meshcols+1) = y(:,meshcols);
end
if mod(rows + 1, meshSize) ~= 0 
    x = [x; zeros(1,meshcols+1)];
    y = [y; zeros(1,meshcols+1)];
    x(meshrows+1,:) = x(meshrows,:);
    y(meshrows+1,:) = rows;
end
x
y

minima = zeros(meshrows, meshcols);
mx = zeros(meshrows, meshcols);
my = zeros(meshrows, meshcols);
data(data == 0) = NaN;

for i = [1:meshrows]
    for j = [1:meshcols]
        % Estrapolazione della regione d'interesse
        % fprintf('%3d-%3d %3d-%3d\n', x(1,j), x(1,j+1), y(i,1), y(i+1,1));
        region = data(y(i,1) : y(i+1,1), x(1,j) : x(1,j+1));
        % Calcolo del minimo nella regione
        [minima(i,j), I] = min(region(:));
        % Aggiunta degli indici
        [mx(i,j), my(i,j)] = ind2sub(size(region), I);
        mx(i,j) = mx(i,j) + x(1,j) - 1;
        my(i,j) = my(i,j) + y(i,1) - 1;
    end
end
minima(minima == 0) = NaN;
[globalMinimum, I] = min(minima(:));
[i, j] = ind2sub(size(minima), I);

imagesc(data);
hold on;
% Plot del grid
plot(x, y, 'w.');
% Plot dei minimi
plot(mx, my, 'g.');
% Plot del minimo globale
plot(mx(i,j), my(i,j), 'y*');
