function coordinates = search_blob_pattern(frame_data, blob_data);
    coordinates = [];

    offset = size(frame_data) - size(blob_data);
    found = false;
    for i = [0:offset(1)]
        for j = [0:offset(2)]
            coordinates = [i + 1 j + 1];
            boundcoordinates = coordinates + size(blob_data) - ones(1,2);
            submat = frame_data(coordinates(1):boundcoordinates(1), coordinates(2):boundcoordinates(2));
            if isequal(submat, blob_data)
                found = true;
            end
            if found
                break;
            end
        end
        if found
            break;
        end
    end

    if ~found
        coordinates = [];
    end
end
