function dst = scale_final_classifier(origin, scale);
    global CLASSIFIER_NAMES;

    dst = struct(origin);
    for name = CLASSIFIER_NAMES
        name = char(name);
        fc = scale_classifier(getfield(origin, name), scale);
        dst = setfield(dst, name, fc);
    end
end
