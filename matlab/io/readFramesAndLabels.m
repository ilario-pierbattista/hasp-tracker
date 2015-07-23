function [frames, labels] = readFramesAndLabels(samples, scaleFactor, floorValue)
% ${2/.*/U/} Effettua le operazioni di preprocessing sugli elementi del
% database di allenamento
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Long description
width = samples(1).width;
height = samples(1).height;
if scaleFactor > 1
    height = round(height/scaleFactor);
    width = round(width/scaleFactor);
end
frames = zeros(height, width, length(samples));
labels = [];
for i = [1:length(samples)]
    frames(:,:,i) = preprocessImage(samples(i), scaleFactor, floorValue);
    labels = [labels samples(i).positive];
end
