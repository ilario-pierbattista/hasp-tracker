function destroyrectangles(fig, rectangles);
    figure(fig);
    for i = [1:length(rectangles)];
        delete(rectangles(i));
    end
end
