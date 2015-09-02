clear all;close all;clc;

%%%Kinect V1_240_320
% rowPixel = 240;
% columnPixel = 320;
% thBlob = 3000;
% kinVr = 'KinectV1_240_320';
% % pathSensor = 'Frames\KinectV1_240_320';
% pathSensor = fullfile(pwd, 'Frames', 'KinectV1_240_320');

% %%%Kinect V1_480_640
% rowPixel = 480;
% columnPixel = 640;
% thBlob = 6000;
% kinVr = 'KinectV1_480_640';
% pathSensor = 'Frames\KinectV1_480_640';

%%%Kinect V2
rowPixel = 424;
columnPixel = 512;
thBlob = 9000;
kinVr = 'KinectV2';
pathSensor = fullfile(pwd, 'Frames', 'KinectV2');

SensorHeight = 3000; %Distance of the sensor from the floor [mm]

%Load reference frame
fileName = fullfile(pathSensor,'ref.bin');
fid = fopen(fileName);
arrayFrame = fread(fid,'uint16');
fclose(fid);
M_ref = zeros(rowPixel, columnPixel);
for r=1:rowPixel
    M_ref(r,:) = arrayFrame((r-1)*columnPixel+1:r*columnPixel);
end
%fill "holes" in depth frame
M_ref = PreprocessingFrame(M_ref,rowPixel,columnPixel,SensorHeight);

%load depth frame
fileName = fullfile(pathSensor,'Filedepth_1.bin');
DF = zeros(rowPixel,columnPixel);
fid = fopen(fileName);
arrayFrame = fread(fid,'uint16');
fclose(fid);
for r=1:rowPixel
    DF(r,:) = arrayFrame((r-1)*columnPixel+1:r*columnPixel);
end
DF_mod = PreprocessingFrame(DF,rowPixel,columnPixel,SensorHeight);

%background substraction: campare DF_mod with M_ref
M_for = zeros(rowPixel,columnPixel);
for r = 1:rowPixel
    for c= 1:columnPixel
        if(abs(DF_mod(r,c) - M_ref(r,c)) > 30)
            M_for(r,c) = DF_mod(r,c);
        end
    end
end

%Median Filter (used to remove the little blobs)
M_filt = medfilt2(M_for,[5 5]);
M_bin = M_filt>0;
%Label all blobs
CC = bwconncomp(M_bin);
%Find the biggest blob
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
MaxBlob = cell2mat(CC.PixelIdxList(idx));

%the biggest blob must has minimum dimension
if biggest > thBlob
    M = zeros(rowPixel,columnPixel);
    M(MaxBlob) = 1; %figure; imagesc(M_pers)
    BC_s = regionprops(M); %BlobCent_struct
    BlobCent = floor(BC_s.Centroid);

    %Dimensions of the bounding box area
    x_rgn = round([BC_s.BoundingBox(1) BC_s.BoundingBox(1)+BC_s.BoundingBox(3)]);
    y_rgn = round([BC_s.BoundingBox(2) BC_s.BoundingBox(2)+BC_s.BoundingBox(4)]);
    if x_rgn(2) > columnPixel
        x_rgn(2) = columnPixel;
    end
    if x_rgn(1) < 1
        x_rgn(1) = 1;
    end
    if y_rgn(2) > rowPixel
        y_rgn(2) = rowPixel;
    end
    if y_rgn(1) < 1
        y_rgn(1) = 1;
    end

    %Find the close pixel to the sensor
    DF_block = DF_mod(y_rgn(1):y_rgn(end),x_rgn(1):x_rgn(end));
    maxElem = find(DF_block == (min(min(DF_block))));
    [row_max,col_max] = ind2sub(size(DF_block),maxElem);

    maxPnt = [row_max(1) col_max(1) DF_block(row_max(1),col_max(1))];

    %Find the center of the head using maxPnt
    maxHeight = 100;
    HeadArea = double(abs(DF_block - maxPnt(3)) < maxHeight);
    [row_head,col_head] = find(HeadArea == 1);
    maxMeanPnt = [floor(mean(row_head)) floor(mean(col_head))];
    maxMeanPnt = [maxMeanPnt DF_block(maxMeanPnt(1),maxMeanPnt(2))];
    maxMeanPnt_DF = [maxMeanPnt(1)+y_rgn(1) maxMeanPnt(2)+x_rgn(1) maxMeanPnt(3)];
    if maxMeanPnt_DF(1) > rowPixel
        maxMeanPnt_DF(1) = rowPixel;
    end
    if maxMeanPnt_DF(2) > columnPixel
        maxMeanPnt_DF(2) = columnPixel;
    end

    %%Check if the blob is a person
    FlagPerson = IsPerson(DF_mod,rowPixel,columnPixel,maxMeanPnt_DF(1:2),SensorHeight,kinVr);

    %Plot results
    figure;
    imagesc(DF); xlabel('[pixel]'); ylabel('[pixel]'); title('[depth frame]');
    figure;
    imagesc(DF_block);
    hold on;
    plot(col_head,row_head,'.r');
    plot(maxPnt(2),maxPnt(1),'.k','markersize',35);
    plot(maxMeanPnt(2),maxMeanPnt(1),'.g','markersize',35)
    title('maxPnt in black - maxMeanPnt in green');
    if FlagPerson ~= -1
        stopDebug = 1;
    end
end
if FlagPerson == -1
    disp('Person not present');
else
    disp('Person present!!');
end
