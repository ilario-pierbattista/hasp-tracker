clear frames;
clear fm;
set_number = input('Frame set da utilizzare[1-5]? ');
frames = getFramesPath(getDatasetPath(set_number));
data = readImageData(char(frames{1}), 320, 240, 16);
ii = integralImage(data);
im = imagesc(ii);
tic;
for i = [1:length(frames)]
    title(strcat('Frame: ', num2str(i)));
    data = readImageData(char(frames{i}), 320, 240, 16);
    set(im, 'CData', mex_integral_image(data));
    drawnow;
end
toc;
