function window = filter_rectangles(rectangles);
    % @TODO il filtro è molto primitivo, va migliorato.
    % Funziona solamente con un soggetto alla volta nel frame
    centers = [];
    for i = [1:size(rectangles, 1)]
        centers = [centers; rectangle_center(rectangles(i, :))];
    end
    number_of_rectangles = size(centers, 1);
    final_x = fix(sum(centers(:,1)) / number_of_rectangles);
    final_y = fix(sum(centers(:,2)) / number_of_rectangles);
    lato = rectangles(1,3);
    tlx = fix(final_x - lato/2);
    tly = fix(final_y - lato/2);
    window = [tlx, tly, lato, lato];
end

function center = rectangle_center(rect);
    lato = rect(3);
    x = rect(1) + lato/2;
    y = rect(2) + lato/2;
    center = [x, y];
end

function result = search_row(matrix, r);
    if isempty(find(ismember(matrix, r, 'rows')))
        result = false;
    else
        result = true;
    end
end
