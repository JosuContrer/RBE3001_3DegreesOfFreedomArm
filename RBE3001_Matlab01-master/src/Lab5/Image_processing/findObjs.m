function balls = findObjs(imOrig, Tzero2check, T_cam_to_checker, cameraParams)
R = T_cam_to_checker(1:3,1:3);
t = T_cam_to_checker(1:3,4);
tcheck0 = Tzero2check;

[imOG, ~] = undistortImage(imOrig, cameraParams, 'OutputView', 'full');

imAVG = imfilter(imOG, [2/9 2/9 2/9; 1/9 2/9 1/9; 0/9 1/9 0/9]); %DO NOT CHANGE THIS LINE
imAVG = imfilter(imAVG, [1/9 1/9 1/9; 1/9 1/12 1/9; 1/9 1/9 1/9]); %DO NOT CHANGE THIS LINE
figure(1)
imshow(imAVG)


%Make ball object with ball color and pixel coordinates
balls = findBalls(imAVG);
bases = findBases(imAVG);

ballSize = size(balls);
baseSize = size(bases);

%convert pixel space to task space coordinates
for i = 1:ballSize(2)
    balls(i) = balls(i).getWorldDim(cameraParams, R, t, tcheck0);
    
    ballX = balls(i).pixelCenter(1);
    ballY = balls(i).pixelCenter(2);
    
    %no bases condition
    if baseSize(2) < 1
        thisbase = base;
        balls(i).base = thisbase.makeBase(0,0,0,'N');
    
    else
        for j = 1:baseSize(2)
            baseX = bases(j).pixelCenter(1);
            baseY = bases(j).pixelCenter(2);
            baseRad = bases(j).pixelRadius;
            basefound = 0;
            if ballX >= baseX - baseRad && ballX <= baseX + baseRad && ballY >= baseY - baseRad && ballY <= baseY + baseRad
                balls(i).base = bases(j);
                basefound = 1;
                break
            elseif j == baseSize(2) && basefound == 0
                thisbase = base;
                balls(i).base = thisbase.makeBase(0,0,0,'N');
            end
        end
    end
end

end