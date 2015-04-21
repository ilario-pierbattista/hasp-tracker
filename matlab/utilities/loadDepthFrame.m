function depth = loadDepthFrame(filename, Ci)

RGB_16 = imread(filename);
RGB_db = double(RGB_16);
depth = RGB_db*Ci ./ 65535;
