function [precence, Wx, Wy] = detectHuman(image, subWindowSize, threshold)
ii = mex_integral_image(image);
[rows cols] = size(image);

[Wx, Wy] = generateWindow(1,1,subWindowSize);
precence = false;

for i = [1:rows]
    if max(Wy(:)) < rows
        for j = [1:cols]
            [Wx, Wy] = generateWindow(j, i, subWindowSize);

            if max(Wx(:)) > cols
                break;
            end

            h = weakClassifiers(ii, Wx, Wy);

            weights(1:length(h)) = 1/length(h);

            if strongClassifier(h, weights, threshold)
                precence = true;
                return;
            end
        end
    end
end
