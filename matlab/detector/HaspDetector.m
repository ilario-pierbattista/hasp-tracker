classdef HaspDetector

    properties
        image;
        width;
        height;
        integral_image;
    end

    methods
        function obj = integralImage(obj)
            obj.integral_image = mex_integral_image(obj.image);
        end

    end

end
