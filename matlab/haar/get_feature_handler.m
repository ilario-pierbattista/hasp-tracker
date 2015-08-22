function handler = get_feature_handler(featureType, topleft, dimension);
    switch featureType
    case 0
        handler = @(img, offset) haar_vertical_edge(img, topleft + offset, dimension);
    case 1
        handler = @(img, offset) haar_horizontal_edge(img, topleft + offset, dimension);
    case 2
        handler = @(img, offset) haar_vertical_linear(img, topleft + offset, dimension);
    case 3
        handler = @(img, offset) haar_horizontal_linear(img, topleft + offset, dimension);
    otherwise
        % Questo statement non dovrebbe essere mai raggiunto
        handler = @(img, offset) haar_vertical_edge(img, topleft + offset, dimension);
    end
end
