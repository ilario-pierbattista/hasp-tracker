function count = countFeatures(width, height, minf, step)
% Ci sono 4 forme di feature
% Le dimensioni sono nella forma larghezza x altezza

% Incremento per ogni feature
if nargin < 3
    % Dimensione minima per ogni feature
    minf = [
        1 2;
        2 1;
        1 3;
        3 1;
        2 2
    ];
end
if nargin < 4
    step = [
        1 2;
        2 1;
        1 3;
        3 1;
        2 2
    ];
end

count = 0;
for i = [1:length(minf(:,1))]
    count = count + featureCombination(width, height, minf(i,:), step(i,:));
end
%end function
end


function count = featureCombination(width, height, minf, step)
% Calcola le combinazioni per ogni feature possibili in una finestra
count = 0;
for i = [minf(1) : step(1) : width]
    for j = [minf(2) : step(2) : height]
        count = count + (width - i + 1)*(height - j +1);
        % Questo dovrebbe essere equivalente, ma più lento
        %for k = [0 : width - i]
        %  for l = [0 : height - j]
        %       count = count + 1;
        %   end
        %end
    end
end
%end function
end
