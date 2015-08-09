function rectangles = drawrectangles(fig, boxes, edgecolor);
    figure(fig);
    rectangles = [];

    for i = [1:size(boxes,1)]
        rectangles = [rectangles; rectangle('Position', boxes(i, :), 'EdgeColor', edgecolor)];
    end
end
