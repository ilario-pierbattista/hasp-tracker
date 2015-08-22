function dst = scale_classifier(origin, scale);
    dst = struct(origin);
    wc = dst.weakClassifiers;
    for i = [1:length(wc)]
        wc(i).feature.topleft = fix(wc(i).feature.topleft * scale);
        % A seconda del tipo di feature, le dimensioni devono essere divisibili
        % per 2 o per 3
        dim = fix(wc(i).feature.dimension * scale);
        switch(wc(i).feature.type)
        case 0
            dim(2) = dim(2) - mod(dim(2), 2);
        case 1
            dim(1) = dim(1) - mod(dim(1), 2);
        case 2
            dim(2) = dim(2) - mod(dim(2), 3);
        case 3
            dim(1) = dim(1) - mod(dim(1), 3);
        otherwise
            dim(2) = dim(2) - mod(dim(2), 2);
        end
        wc(i).feature.dimension = dim;
        handler = get_feature_handler(wc(i).feature.type, ...
            wc(i).feature.topleft, wc(i).feature.dimension);
        wc(i).feature.calculate = handler;
        classifierFunc = get_classifier_function(wc(i).feature,...
            wc(i).polarity, wc(i).threshold);
        wc(i).classify = classifierFunc;
    end
    dst.weakClassifiers = wc;
end
