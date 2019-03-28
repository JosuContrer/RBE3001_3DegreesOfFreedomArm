close all
clear
clc
clear
clc
clear java
%clear import;
clear classes;
vid = hex2dec('3742');
pid = hex2dec('0007');
disp (vid );
disp (pid);
javaaddpath ../lib/SimplePacketComsJavaFat-0.6.4.jar;
import edu.wpi.SimplePacketComs.*;
import edu.wpi.SimplePacketComs.device.*;
import edu.wpi.SimplePacketComs.phy.*;
import java.util.*;
import org.hid4java.*;
version -java;
myHIDSimplePacketComs=HIDfactory.get();
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();
% Create a PacketProcessor object to send data to the nucleo firmware
global pp;
pp = PacketProcessor(myHIDSimplePacketComs); 
pause(0.003);

global PID_SERV_ID;
global PIDCONFIG_SERV_ID;
global STATUS_SERV_ID;
global SERVO_SERVER_ID;
PID_SERV_ID = 01;
PIDCONFIG_SERV_ID= 02;
STATUS_SERV_ID = 03;
SERVO_SERVER_ID = 05;

setPID(0.001, 0.0001, 0.01, ...
        0.005, 0.0001, 0.06, ...
        0.001, 0.0001, 0.01, ...
        pp, PIDCONFIG_SERV_ID);
    
moveGripper(95,pp, SERVO_SERVER_ID);

homePos = [20, 0, 200];
homeAngles = ikin(homePos);
moveArmAngles(homeAngles(1), homeAngles(2), homeAngles(3), pp, PID_SERV_ID);


Tcam2check = [0.0038   -0.8494    0.5277  100.0240;
    1.0000    0.0030   -0.0025   90.0785;
    0.0005    0.5277    0.8494  294.2280;
         0         0         0    1.0000];
     
Tzero2check = tdh(175+52.8+48,0,0,0)*tdh(0, 0, 0, 90)*tdh(101.6+12,0,0,0)*tdh(0,180,0,90);

%audio setup
[yYellow, FsYellow] = audioread('Lab5/Audio/yellow.wav');
[yBlue, FsBlue] = audioread('Lab5/Audio/blue.wav');
[yGreen, FsGreen] = audioread('Lab5/Audio/green.wav');
[yBig, FsBig] = audioread('Lab5/Audio/large.wav');
[ySmall, FsSmall] = audioread('Lab5/Audio/small.wav');
[yDone, FsDone] = audioread('Lab5/Audio/done.wav');
[yBye, FsBye] = audioread('Lab5/Audio/bye.wav');
[yMail, FsMail] = audioread('Lab5/Audio/mail.wav');

%make camera object
cam = webcam();
lab5_cameraParams();
close all

%capture image
imageOG = snapshot(cam);

%process image
balls = findObjs(imageOG, Tzero2check, Tcam2check, cameraParams);
ballSize = size(balls);

sound(yMail, FsMail, 16);
while ballSize(2) > 0
    contV = 1;
    %sort first ball with a base object in balls
    ball = ball;
    ballFound = 0;
    for i = 1:ballSize(2)
        if balls(i).base.size == 'S' || balls(i).base.size == 'L'
            ball = balls(i);
            ballFound = 1;
            break
        end
    end
    if ballFound == 0
        break
    end
    
    overBallAngles = ikinCamera([ball.worldCenter(1) ball.worldCenter(2) 30]);
    
    %move over ball
    J0_t0 = 0;
    J0_t1 = 6;
    J0_a0 = 0;
    J0_a1 = 0;
    J0_v0 = 0;
    J0_v1 = 0;
    J0_p0 = homeAngles(1);
    J0_p1 = overBallAngles(1);

    J1_t0 = 0;
    J1_t1 = 6;
    J1_a0 = 0;
    J1_a1 = 0;
    J1_v0 = 0;
    J1_v1 = 0;
    J1_p0 = homeAngles(2);
    J1_p1 = overBallAngles(2);

    J2_t0 = 0;
    J2_t1 = 6;
    J2_a1 = 0;
    J2_a0 = 0;
    J2_v0 = 0;
    J2_v1 = 0;
    J2_p0 = homeAngles(3);
    J2_p1 = overBallAngles(3);

    %First movement
    J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, J0_v0, contV, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, J1_v0, contV, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, J2_v0, contV, J2_p0, J2_p1);
    
    t = 0;
    tic
    while t <= 6
        t = toc;
        J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
        J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
        J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
        moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    end
    %move down to ball
    ballAngles = ikinCamera([ball.worldCenter(1) ball.worldCenter(2) -30]);
    
    J0_p0 = overBallAngles(1);
    J0_p1 = ballAngles(1);
    J1_p0 = overBallAngles(2);
    J1_p1 = ballAngles(2);
    J2_p0 = overBallAngles(3);
    J2_p1 = ballAngles(3);
    
    J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, contV, J0_v1, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, contV, J1_v1, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, contV, J2_v1, J2_p0, J2_p1);
    
    t = 0;
    tic
    while t <= 6
        t = toc;
        J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
        J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
        J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
        moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    end
    
    %grip ball
    moveGripper(0,pp, SERVO_SERVER_ID);
    
    %position to place ball
    sortPos = [0 0];
    
    %identify color
    if ball.color == 'y'
        sound(yYellow, FsYellow, 16);
        sortPos(1) = 35;
    elseif ball.color == 'g'
        sound(yGreen, FsGreen, 16);
        sortPos(1) = -65;
    elseif ball.color == 'b'
        sound(yBlue, FsBlue, 16);
        sortPos(1) = -140;
    end
    
    pause(1);
    
    %identify base size
    if ball.base.size == 'L'
        sound(yBig, FsBig, 16);
        sortPos(2) = -210;
%       sortAngles = ikin([0 -200 150]);
    else
        sound(ySmall, FsSmall, 16);
        sortPos(2) = 210;
%       sortAngles = ikin([0 200 150]);
    end
    
    %move up
    J0_p0 = ballAngles(1);
    J0_p1 = overBallAngles(1);
    J1_p0 = ballAngles(2);
    J1_p1 = overBallAngles(2);
    J2_p0 = ballAngles(3);
    J2_p1 = overBallAngles(3);
    
    up_t1 = 5;
    
    J0_j = quintic(J0_t0, up_t1, J0_a0, J0_a1, J0_v0, contV, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, up_t1, J1_a0, J1_a1, J1_v0, contV, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, up_t1, J2_a0, J2_a1, J2_v0, contV, J2_p0, J2_p1);
    
    t = 0;
    tic
    while t <= 5
        t = toc;
        J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
        J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
        J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
        moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    end
    
    %Sort Ball
    sortAngles = ikin([sortPos(1),sortPos(2), 50]);     %inverse Kinematics
    
    J0_p0 = overBallAngles(1);
    J0_p1 = sortAngles(1);
    J1_p0 = overBallAngles(2);
    J1_p1 = sortAngles(2);
    J2_p0 = overBallAngles(3);
    J2_p1 = sortAngles(3);
    
    J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, contV, J0_v1, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, contV, J1_v1, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, contV, J2_v1, J2_p0, J2_p1);
    
    t = 0;
    tic
    while t <= 6
        t = toc;
        J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
        J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
        J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
        moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    end
    
    %Lower Ball
    lowerAngles = ikin([sortPos(1),sortPos(2), 0]);  %inverse Kinematics
    
    J0_p0 = sortAngles(1);
    J0_p1 = lowerAngles(1);
    J1_p0 = sortAngles(2);
    J1_p1 = lowerAngles(2);
    J2_p0 = sortAngles(3);
    J2_p1 = lowerAngles(3);
    
    J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, J0_v0, J0_v1, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, J1_v0, J1_v1, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, J2_v0, J2_v1, J2_p0, J2_p1);
    
    t = 0;
    tic
    while t <= 6
        t = toc;
        J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
        J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
        J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
        moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    end
    
    %drop ball
    moveGripper(95,pp, SERVO_SERVER_ID);
    pause(1);
    
    %move up
    raiseAngles = ikin([sortPos(1),sortPos(2), 40]);  %inverse Kinematics
    
    J0_p0 = lowerAngles(1);
    J0_p1 = raiseAngles(1);
    J1_p0 = lowerAngles(2);
    J1_p1 = raiseAngles(2);
    J2_p0 = lowerAngles(3);
    J2_p1 = raiseAngles(3);
    
    J0_j = quintic(J0_t0, 3, J0_a0, J0_a1, J0_v0, 3, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, 3, J1_a0, J1_a1, J1_v0, 3, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, 3, J2_a0, J2_a1, J2_v0, 3, J2_p0, J2_p1);
    
    t = 0;
    tic
    while t <= 3
        t = toc;
        J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
        J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
        J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
        moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    end
    
    
    %return home
    moveArmAngles(homeAngles(1), homeAngles(2), homeAngles(3), pp, PID_SERV_ID);
    
    close all
    imageOG = snapshot(cam);
    balls = findObjs(imageOG, Tzero2check, Tcam2check, cameraParams);
    ballSize = size(balls);
end
sound(yDone, FsDone, 16);
pause(1.6);
sound(yBye, FsBye, 16);

pp.shutdown()