function image = preprocessImage(sample, scaleFactor, floorValue)
% ${2/.*/U/} Preprocessa un'immagine
%    ${1/.*/U/} = ${2/.*/U/}()
%
% Long description
image = readImageData(sample.filepath, sample.width, sample.height, 16);
image = floor_rebase(image, floorValue);
image = integral_image(image);
if scaleFactor > 1
    image = scale_image(image, scaleFactor);
end
