addpath(strcat(userpath, '/functions'));
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

%Define Server Numbers
global PID_SERV_ID;
global PIDCONFIG_SERV_ID;
global STATUS_SERV_ID;
PID_SERV_ID = 01;
PIDCONFIG_SERV_ID= 02;
STATUS_SERV_ID = 03;

%open cs file
fid = fopen('lab3_values_question8.csv','w');

setPID(0.001, 0.0001, 0.01, ...
        0.009, 0.0001, 0.06, ...
        0.001, 0.0001, 0.01, ...
        pp, PIDCONFIG_SERV_ID);
pos1 = [15 0 30];
pos2 = [30 -200 60];
pos3 = [-10 200 120];

angles = ikin(pos1);
moveArmAngles(angles(1),angles(2),angles(3),pp,PID_SERV_ID); %move to start position

%Joint positions
pos1Angles = ikin(pos1);
pos2Angles = ikin(pos2);
pos3Angles = ikin(pos3);

%Velocity Variables
oldTime = 0;
oldAngles = [0,0,0];

%define cubic variables
J0_t0 = 0;
J0_t1 = 8;
J0_a0 = 0;
J0_a1 = 0;
J0_v0 = 0;
J0_v1 = 0;
J0_p0 = pos1Angles(1);
J0_p1 = pos2Angles(1);
  
J1_t0 = 0;
J1_t1 = 8;
J1_a0 = 0;
J1_a1 = 0;
J1_v0 = 0;
J1_v1 = 0;
J1_p0 = pos1Angles(2);
J1_p1 = pos2Angles(2);

J2_t0 = 0;
J2_t1 = 8;
J2_a1 = 0;
J2_a0 = 0;
J2_v0 = 0;
J2_v1 = 0;
J2_p0 = pos1Angles(3);
J2_p1 = pos2Angles(3);

t = 0;
%First movement
J0_j = cubic(J0_t0, J0_t1, J0_v0, J0_v1, J0_p0, J0_p1);
J1_j = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_j = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);

%open figure
figure

%start timer
tic
while t <= 25
    t = toc;
    %find setpoints for current time
    J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3));
    J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3));
    J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3));
    %move to setpoint
    moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
     
    angles = readArm(pp, STATUS_SERV_ID)  %read joint angles

    A = jacob0(angles(1),angles(2),angles(3))*(jacob0(angles(1),angles(2),angles(3))).'; %J*JT
    A = [ A(1) A(7) A(13); %isolate roration matrix
        A(2) A(8) A(14);
        A(3) A(9) A(15)];
    T = fwkin3001(angles); %calculate end effector position
    hold off
    delete(findall(gcf,'type','annotation'));
    threeD_joint_plot(angles); %live plot arm
    hold on
    plot_ellipse(A, T); %plot ellipse
    try 
        jacobError(angles(1),angles(2),angles(3))
    catch
        warning('caught an error');
        text = annotation('textbox','String', 'Attempted to enter singularity');
        text.Color = 'red';
    end
    hold off
end

pp.shutdown();
