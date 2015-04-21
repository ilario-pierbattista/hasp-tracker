clear frames;
clear fm;
set_number = input('Frame set da utilizzare[1-5]? ')
frames = getFramesPath(getDatasetPath(set_number));
weights = [0.1;0];
fm = generateFilterMatrix(320, 240, 16, weights);
im = image(readImageData(char(frames{1}), 320, 240, 16, fm));
for i = [1:length(frames)]
    data = readImageData(char(frames{i}), 320, 240, 16, fm);
    set(im, 'CData', data);
    drawnow
end
