close all
clear
clc

%capture image to indentify pixel coordinates
cam = webcam();
lab5_cameraParam;

image = snapshot(cam);

imshow(image);

%pixel coordinates
point1 = [59 420];
point2 = [121 151];
point3 = [481 150];
point4 = [534 422];

points = [point1; point2; point3; point4];

%Transformation Frame
Tcam_2_checker = getCamToCheckerboard(cam, cameraParams);

R = Tcam_2_checker(1:3,1:3);
t = Tcam_2_checker(1:3,4);

worldPoints = pointsToWorld(cameraParams, R, t, points)