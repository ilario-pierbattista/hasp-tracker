function window = filter_rectangles(rectangles, human);
    % @TODO il filtro è molto primitivo, va migliorato.
    % Funziona solamente con un soggetto alla volta nel frame
     global DETECTION_GRANULARITY;
    % Calcolo dei centri
    lato_mezzi = rectangles(:,3) / 2;
    centers = [rectangles(:,1) + lato_mezzi, rectangles(:,2) + lato_mezzi];

    if isempty(human)
        number_of_rectangles = size(centers, 1);
        final_x = fix(sum(centers(:,1)) / number_of_rectangles);
        final_y = fix(sum(centers(:,2)) / number_of_rectangles);
    else
        human_center = repmat(rectangle_center(human), size(centers, 1), 1);
        distances = sqrt(sum((human_center - centers).^2, 2));
        % weight = 1 ./ (distances ./ (DETECTION_GRANULARITY * 2) + 1);
        weight = -atan(distances + DETECTION_GRANULARITY) ./ pi + 0.5;
        % Calcolo del centro di massa
        weighted_centers = centers .* repmat(weight, 1, 2);
        weights_sum = sum(weight, 1);
        final_x = fix(sum(weighted_centers(:,1)) / weights_sum);
        final_y = fix(sum(weighted_centers(:,2)) / weights_sum);
    end
    lato = rectangles(1,3);
    tlx = fix(final_x - lato/2);
    tly = fix(final_y - lato/2);
    window = [tlx, tly, lato, lato];
end

function center = rectangle_center(r);
    center = [r(1) + r(3)/2, r(2) + r(3)/2];
end

function result = search_row(matrix, r);
    if isempty(find(ismember(matrix, r, 'rows')))
        result = false;
    else
        result = true;
    end
end
