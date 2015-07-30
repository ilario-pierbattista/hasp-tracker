%mathematical morphology operation (closing) to the Point cloud

clear all;close all;clc;
rowPixel = 480;
columnPixel = 640;

%load depth frame
load('depthFrame.mat');
figure;
imagesc(depthFrame); xlabel('[pixel]'); ylabel('[pixel]'); title('[depth frame]');

%from depth frame to PC
load CalibrationParam; %depth camera (Kinect V1 - ceiling) intrinsic parameters
depth_intrinsics
cameraMatrix = depth_intrinsics;
blobDim = sum(sum(depthFrame > 0));
XYZ_world = zeros(5,blobDim);
XYZ_idx = 1;
for v= 1:rowPixel
    for u= 1:columnPixel
        if(depthFrame(v,u)~= 0)
            XYZ_world(1,XYZ_idx) = ((u-cameraMatrix(1,3))/cameraMatrix(1,1))*depthFrame(v,u);
            XYZ_world(2,XYZ_idx) = ((v-cameraMatrix(2,3))/cameraMatrix(2,2))*depthFrame(v,u);
            XYZ_world(3,XYZ_idx) = depthFrame(v,u);
            XYZ_world(4,XYZ_idx) = v;
            XYZ_world(5,XYZ_idx) = u;
            XYZ_idx = XYZ_idx + 1;
        end
    end
end
%Plot PC
PC = ceil(XYZ_world(1:3,:));
figure;
subplot 122
plot3(PC(1,:),PC(2,:),PC(3,:),'.b');
set(gca,'ydir','reverse');
set(gca,'zdir','reverse');
axis equal;
xlabel('x [mm]');ylabel('y [mm]');zlabel('z [mm]');
title('Point cloud - top view');
view(0,90);
subplot 121
plot3(PC(1,:),PC(2,:),PC(3,:),'.b');
set(gca,'ydir','reverse');
set(gca,'zdir','reverse');
axis equal;
view(-36,24);
title('Point cloud - side view');

%From PC to PC frame
max_x = max(PC(1,:)); min_x = min(PC(1,:)); max_y = max(PC(2,:)); min_y = min(PC(2,:));
row_dim = abs(max_y-min_y)+1;
col_dim = abs(max_x-min_x)+1;
PC_f = zeros(row_dim,col_dim);
PC_shift = PC;
PC_shift(1,:) = PC(1,:)-min_x+1; PC_shift(2,:) = PC(2,:)- min_y+1;
figure;
plot3(PC_shift(1,:),PC_shift(2,:),PC_shift(3,:),'.b');
set(gca,'ydir','reverse');
set(gca,'zdir','reverse');
axis equal;
xlabel('x [mm]');ylabel('y [mm]');zlabel('z [mm]'); title('Point cloud shifted');
view(0,90);
PC_f(PC_shift(2,:)+(PC_shift(1,:)-1)*row_dim) = PC_shift(3,:);
figure;
imagesc(PC_f)
xlabel('x [mm]');ylabel('y [mm]'); title('Point cloud "frame"');

%fill zero values (mathematical morphology closing)
se = strel('disk',10);
PC_f_fill = imclose(PC_f,se);
figure;
imagesc(PC_f_fill)
xlabel('x [mm]');ylabel('y [mm]'); title('Point cloud "frame" filled');

% PC_fill = zeros(3,row_dim*col_dim);
% PC_fill_idx = 1;
% for PC_fill_r = 1:row_dim
%     for PC_fill_c = 1:col_dim
%         if PC_f_fill(PC_fill_r,PC_fill_c) > 0
%             PC_fill(:,PC_fill_idx) = [PC_fill_r PC_fill_c PC_f_fill(PC_fill_r,PC_fill_c)]';
%             PC_fill_idx = PC_fill_idx + 1;
%         end
%     end
% end
% PC_fill = PC_fill(:,1:(PC_fill_idx-1));
% figure;
% plot3(PC_fill(1,:),PC_fill(2,:),PC_fill(3,:),'.b');
% set(gca,'ydir','reverse');
% set(gca,'zdir','reverse');
% view(56,32);
