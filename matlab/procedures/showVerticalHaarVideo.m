clear frames;
clear fm;
set_number = input('Frame set da utilizzare[1-5]? ');
hfd = input('Dimensione delle features di haar?');
frames = getFramesPath(getDatasetPath(set_number));
im = imagesc(readImageData(char(frames{1}), 320, 240, 16));
tic;
for i = [1:length(frames)]
    data = readImageData(char(frames{i}), 320, 240, 16);
    ii = mex_integral_image(data);
    [Hx, Hy] = mex_haar_features(ii, hfd);
    set(im, 'CData', Hx);
    title(strcat('Frame: ', num2str(i)));
    drawnow;
end
toc;
