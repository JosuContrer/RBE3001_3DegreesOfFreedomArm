function cars = findCarObjs(imOrig, Tzero2check, T_cam_to_checker, cameraParams)
R = T_cam_to_checker(1:3,1:3);
t = T_cam_to_checker(1:3,4);
tcheck0 = Tzero2check;

[imOG, ~] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');

imAVG = imfilter(imOG, [2/9 2/9 2/9; 1/9 2/9 1/9; 0/9 1/9 0/9]); %DO NOT CHANGE THIS LINE
imAVG = imfilter(imAVG, [1/9 1/9 1/9; 1/9 1/12 1/9; 1/9 1/9 1/9]); %DO NOT CHANGE THIS LINE
imshow(imAVG)


%Make ball object with ball color and pixel coordinates

cars = findCars(imAVG);
 
numCars = size(cars);
for i = 1: numCars(2)
    cars(i) = cars(i).getWorldDim(cameraParams, R, t, tcheck0);
end

end