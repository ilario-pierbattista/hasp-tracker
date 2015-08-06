function image = preprocessImage(data, scaleFactor, floorValue);
    if isstruct(data)
        image = readImageData(data.filepath, data.width, data.height, 16);
    else
        image = data;
    end

    image = floor_rebase(image, floorValue);
    image = integral_image(image);
    if scaleFactor > 1
        image = scale_image(image, scaleFactor);
    end
end
