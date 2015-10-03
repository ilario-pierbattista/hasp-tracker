function coordinates = search_blob_pattern(frame_data, blob_data);
    coordinates = [];

    offset = size(frame_data) - size(blob_data);
    found = false;
    for i = [0:offset(1)]
        for j = [0:offset(2)]
            coordinates = [i + 1 j + 1];
            boundcoordinates = coordinates + size(blob_data) - ones(1,2);
            submat = frame_data(coordinates(1):boundcoordinates(1), coordinates(2):boundcoordinates(2));
            % for k = [1:length(blob_data(:))]
            %    [blob_x, blob_y] = ind2sub(size(blob_data), k);
            %    point = [i + blob_x, j + blob_y];
            %    if frame_data(point(1), point(2)) ~= blob_data(blob_x, blob_y)
            %        found = false;
            %        break;
            %    end
            %    found = true;
            %end
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
