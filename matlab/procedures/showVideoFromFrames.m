clear frames;
clear fm;
set_number = input('Frame set da utilizzare[1-5]? ');
frames = getFramesPath(getDatasetPath(set_number));
im = imagesc(readImageData(char(frames{1}), 320, 240, 16));
for i = [1:length(frames)]
    data = readImageData(char(frames{i}), 320, 240, 16);
    set(im, 'CData', data);
    drawnow
end
