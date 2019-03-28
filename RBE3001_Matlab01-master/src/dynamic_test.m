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

%make camera object
cam = webcam();
lab5_cameraParams();
close all

%capture image
imageOG = snapshot(cam);

%process image
balls = findObjs(imageOG, Tzero2check, Tcam2check, cameraParams);

ballSize = size(balls);

%states
FIND_BALLS = 1;
MOVE_ABOVE_BALL = 2;
MOVE_DOWN_BALL = 3;
FINISH_JOB = 4;

State = FIND_BALLS;

%initialize variables 
    J0_t0 = 0;
    J0_t1 = 0;
    J0_a0 = 0;
    J0_a1 = 0;
    J0_v0 = 0;
    J0_v1 = 0;
    J0_p0 = 0;
    J0_p1 = 0;

    J1_t0 = 0;
    J1_t1 = 0;
    J1_a0 = 0;
    J1_a1 = 0;
    J1_v0 = 0;
    J1_v1 = 0;
    J1_p0 = 0;
    J1_p1 = 0;

    J2_t0 = 0;
    J2_t1 = 0;
    J2_a1 = 0;
    J2_a0 = 0;
    J2_v0 = 0;
    J2_v1 = 0;
    J2_p0 = 0;
    J2_p1 = 0;

    overBallAngles = [0 0 0];
    
    %First movement
    J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, J0_v0, J0_v1, J0_p0, J0_p1);
    J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, J1_v0, J1_v1, J1_p0, J1_p1);
    J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, J2_v0, J2_v1, J2_p0, J2_p1);
     moveArmAngles(homeAngles(1), homeAngles(2), homeAngles(3), pp, PID_SERV_ID);
while 1
    switch State
          case FIND_BALLS
            close all
            imageOG = snapshot(cam);
            balls = findObjs(imageOG, Tzero2check, Tcam2check, cameraParams);
            ballSize = size(balls);
            while ballSize(2) > 0
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
            threshold = 5;
            overBallAngles = ikinCamera([ball.worldCenter(1) ball.worldCenter(2) 30]);
            armAngles = readArm(pp,STATUS_SERV_ID);
            effector = fwkin3001(armAngles)
            ballcoord = [ball.worldCenter(1) ball.worldCenter(2) 30]
            State = MOVE_ABOVE_BALL;
            break;
            end
 
       
        case MOVE_ABOVE_BALL
            armAngles = readArm(pp,STATUS_SERV_ID);
            J0_t0 = 0;
            J0_t1 = 10;
            J0_a0 = 0;
            J0_a1 = 0;
            J0_v0 = 0;
            J0_v1 = 0;
            J0_p0 = armAngles(1);
            J0_p1 = overBallAngles(1);

            J1_t0 = 0;
            J1_t1 = 10;
            J1_a0 = 0;
            J1_a1 = 0;
            J1_v0 = 0;
            J1_v1 = 0;
            J1_p0 = armAngles(2);
            J1_p1 = overBallAngles(2);

            J2_t0 = 0;
            J2_t1 = 10;
            J2_a1 = 0;
            J2_a0 = 0;
            J2_v0 = 0;
            J2_v1 = 0;
            J2_p0 = armAngles(3);
            J2_p1 = overBallAngles(3);

            %First movement
            J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, J0_v0, J0_v1, J0_p0, J0_p1);
            J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, J1_v0, J1_v1, J1_p0, J1_p1);
            J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, J2_v0, J2_v1, J2_p0, J2_p1);

            t = 0;
            while t <= 10
                t = t+1;
                J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
                J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
                J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
                moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
                close all
                imageOG = snapshot(cam);
                balls = findObjs(imageOG, Tzero2check, Tcam2check, cameraParams);
                newBall = balls(1);
                newBallCoord = [newBall.worldCenter(1) newBall.worldCenter(2) -30]
                threshold = 3;
                if abs(ballcoord(1) - newBall.worldCenter(1)) >= threshold || abs(ballcoord(2) - newBall.worldCenter(2)) >= threshold
                    State = FIND_BALLS;
                    break;
                end
            end
            if State == MOVE_ABOVE_BALL
                State = MOVE_DOWN_BALL;
            end
            
       
    
    case MOVE_DOWN_BALL
        ballAngles = ikinCamera([ball.worldCenter(1) ball.worldCenter(2) -30]);

        J0_p0 = overBallAngles(1);
        J0_p1 = ballAngles(1);
        J1_p0 = overBallAngles(2);
        J1_p1 = ballAngles(2);
        J2_p0 = overBallAngles(3);
        J2_p1 = ballAngles(3);

        J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, J0_v0, J0_v1, J0_p0, J0_p1);
        J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, J1_v0, J1_v1, J1_p0, J1_p1);
        J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, J2_v0, J2_v1, J2_p0, J2_p1);

        t = 0;
        tic
        while t <= 10
            t = toc;
            J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
            J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
            J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
            moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
         
        end
        State = FINISH_JOB;
        
        case FINISH_JOB
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

            J0_j = quintic(J0_t0, up_t1, J0_a0, J0_a1, J0_v0, J0_v1, J0_p0, J0_p1);
            J1_j = quintic(J1_t0, up_t1, J1_a0, J1_a1, J1_v0, J1_v1, J1_p0, J1_p1);
            J2_j = quintic(J2_t0, up_t1, J2_a0, J2_a1, J2_v0, J2_v1, J2_p0, J2_p1);

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
            sortAngles = ikin([sortPos(1),sortPos(2), 150]);     %inverse Kinematics

            J0_p0 = overBallAngles(1);
            J0_p1 = sortAngles(1);
            J1_p0 = overBallAngles(2);
            J1_p1 = sortAngles(2);
            J2_p0 = overBallAngles(3);
            J2_p1 = sortAngles(3);

            J0_j = quintic(J0_t0, J0_t1, J0_a0, J0_a1, J0_v0, J0_v1, J0_p0, J0_p1);
            J1_j = quintic(J1_t0, J1_t1, J1_a0, J1_a1, J1_v0, J1_v1, J1_p0, J1_p1);
            J2_j = quintic(J2_t0, J2_t1, J2_a0, J2_a1, J2_v0, J2_v1, J2_p0, J2_p1);

            t = 0;
            tic
            while t <= 10
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
            while t <= 10
                t = toc;
                J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3) + (J0_j(5)*t^4) + (J0_j(6)*t^5));
                J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3) + (J1_j(5)*t^4) + (J1_j(6)*t^5));
                J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3) + (J2_j(5)*t^4) + (J2_j(6)*t^5));
                moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
            end

            %drop ball
            moveGripper(95,pp, SERVO_SERVER_ID);
            pause(1);

            %return home
            moveArmAngles(homeAngles(1), homeAngles(2), homeAngles(3), pp, PID_SERV_ID);

            close all
            imageOG = snapshot(cam);
            balls = findObjs(imageOG, Tzero2check, Tcam2check, cameraParams);
            ballSize = size(balls);
            break;
          end
end
% moveGripper(95,pp, SERVO_SERVER_ID);
% angles = ikinCamera([balls(1).worldCenter(1) balls(1).worldCenter(2) 18]);
% moveArmAngles(angles(1), angles(2), angles(3), pp, PID_SERV_ID);
% pause(3);
% angles = ikinCamera([balls(1).worldCenter(1) balls(1).worldCenter(2) -12]);
% moveArmAngles(angles(1), angles(2), angles(3), pp, PID_SERV_ID);
% moveGripper(0,pp, SERVO_SERVER_ID);
pp.shutdown()