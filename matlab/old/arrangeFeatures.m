function features = arrangeFeatures(width, height, minf, step)
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

features = [];
for i = [1:length(minf(:,1))]
    features = [
        features; 
        featureCombination(width, height,...
            minf(i,:), step(i,:))
    ];
end
%end function
end


function features = featureCombination(width, height, minf, step)
% Calcola le combinazioni per ogni feature possibili in una finestra
features = [];
for i = [minf(1) : step(1) : width]
    for j = [minf(2) : step(2) : height]
        for k = [0 : width - i]
            for l = [0 : height - j]
                features = [
                    features;
                    [ k l i j ]
                ];
            end
        end
    end
end
%end function
end
