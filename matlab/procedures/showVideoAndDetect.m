clear frames;
clear fm;
set_number = input('Frame set da utilizzare[1-5]? ');
set_subWindowSize = input('Grandezza delle sottofinestre? ');
set_threshold = input('Valore di soglia? ');

frames = getFramesPath(getDatasetPath(set_number));
im = imagesc(readImageData(char(frames{1}), 320, 240, 16));
hold on;
tic;
h = zeros(1, length(frames));
for i = [1:length(frames)]
    data = readImageData(char(frames{i}), 320, 240, 16);
    [precence, Wx, Wy] = detectHuman(data, set_subWindowSize, set_threshold);
    if(precence)
        plot(Wx(3,4), Wy(3,4), 'y*');
    end
    set(im, 'CData', data);
    title(strcat('Frame: ', num2str(i)));
    drawnow;
end
toc;
