clear frames;
clear fm;
set_number = input('Frame set da utilizzare[1-5]? ');
sub_with_nans = input('Calcolare il punto di minimo? [yN] ', 's');
if ~strcmp(sub_with_nans, 'y')
    sub_with_nans = false;
else
    sub_with_nans = true;
    hold on;
end
frames = getFramesPath(getDatasetPath(set_number));
im = imagesc(readImageData(char(frames{1}), 320, 240, 16));
tic;
h = zeros(1, length(frames));
for i = [1:length(frames)]
    data = readImageData(char(frames{i}), 320, 240, 16);
    if sub_with_nans
        if i ~= 1
            delete(h(i-1));
        end
        data(data == 0) = NaN;
        [m, I] = min(data(:));
        [row_i, col_i] = ind2sub(size(data), I);
        % Bisogna inserire il marker
        h(i) = plot(col_i, row_i, 'y*');
    end 
    set(im, 'CData', data);
    title(strcat('Frame: ', num2str(i)));
    drawnow;
end
toc;
