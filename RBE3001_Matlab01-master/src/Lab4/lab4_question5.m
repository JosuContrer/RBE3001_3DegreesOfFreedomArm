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

oldAngles = readArm(pp, STATUS_SERV_ID);

%start timer
tic
while t <= 8
    t = toc;
    J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3));
    J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3));
    J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3));
    moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    angles = readArm(pp, STATUS_SERV_ID);
    angleVel = (angles-oldAngles)/(t-oldTime); 
    endVel = difkin(angles, angleVel);
    threeD_vel_vector(angles, endVel)
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
    oldAngles = angles;
    oldTime = t;
end

%define variables
J0_t0 = 8;
J0_t1 = 16;
J0_p0 = pos2Angles(1);
J0_p1 = pos3Angles(1);

J1_t0 = 8;
J1_t1 = 16;
J1_p0 = pos2Angles(2);
J1_p1 = pos3Angles(2);

J2_t0 = 8;
J2_t1 = 16;
J2_p0 = pos2Angles(3);
J2_p1 = pos3Angles(3);

t = 0;
%Second movement
J0_j = cubic(J0_t0, J0_t1, J0_v0, J0_v1, J0_p0, J0_p1);
J1_j = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_j = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);

while t <= 16
    t = toc;
    J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3));
    J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3));
    J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3));
    moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
   angles = readArm(pp, STATUS_SERV_ID);
    angleVel = (angles-oldAngles)/(t-oldTime); 
    endVel = difkin(angles, angleVel);
    threeD_vel_vector(angles, endVel)
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
    oldAngles = angles;
    oldTime = t;
end

%define variables
J0_t0 = 16;
J0_t1 = 24;
J0_p0 = pos3Angles(1);
J0_p1 = pos1Angles(1);

J1_t0 = 16;
J1_t1 = 24;
J1_p0 = pos3Angles(2);
J1_p1 = pos1Angles(2);

J2_t0 = 16;
J2_t1 = 24;
J2_p0 = pos3Angles(3);
J2_p1 = pos1Angles(3);

t = 0;
%Third movement
J0_j = cubic(J0_t0, J0_t1, J0_v0, J0_v1, J0_p0, J0_p1);
J1_j = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_j = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);

while t <= 24
    t = toc;
    J0_setPoint = ((J0_j(1)) + (J0_j(2)*t) + (J0_j(3)*t^2) + (J0_j(4)*t^3));
    J1_setPoint = ((J1_j(1)) + (J1_j(2)*t) + (J1_j(3)*t^2) + (J1_j(4)*t^3));
    J2_setPoint = ((J2_j(1)) + (J2_j(2)*t) + (J2_j(3)*t^2) + (J2_j(4)*t^3));
    moveArmAngles(J0_setPoint, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
   angles = readArm(pp, STATUS_SERV_ID);
    angleVel = (angles-oldAngles)/(t-oldTime); 
    endVel = difkin(angles, angleVel);
    threeD_vel_vector(angles, endVel)
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
    oldAngles = angles;
    oldTime = t;
end

% %plot path in task space
% out = csvread('lab3_values_question8.csv');
% 
% endX = out(1, 4);
% endY = out(1, 5);
% endZ = out(1, 6);
% 
% 
% for i = 2:size(out)
%     %plot for endefector
%     time = out(i,7);
%     plot3([endX out(i,4)],[endY out(i,5)], [endZ out(i,6)], 'r-');
%     plot3(pos1(1)+175,pos1(2),pos1(3), 'bo');
%     plot3(pos2(1)+175,pos2(2),pos2(3),'go');
%     plot3(pos3(1)+175,pos3(2),pos3(3), 'mo');
%     hold on
%     grid on
%     title('End Effector Triangle in 3D')
%     xlabel('X-axis(mm)')
%     ylabel('Y-axis(mm)')
%     zlabel('Z-axis(mm)')
%     %Save value for line generation
%     endX = out(i,4);
%     endY = out(i,5);
%     endZ = out(i,6);
% end
% figure
% oldTime = 0;
% oldX  = out(1,4);
% oldY  = out(1,5);
% oldZ  = out(1,6);
% for i = 2:size(out)
%     plot([oldTime out(i,7)],[oldX out(i,4)],'r-',[oldTime out(i,7)],[oldY out(i,5)],'b-',[oldTime out(i,7)],[oldZ out(i,6)],'g-')
%     oldX  = out(i,4);
%     oldY  = out(i,5);
%     oldZ  = out(i,6);
%     oldTime = out(i,7);
%     hold on
%     grid on
%     title('End Effector Triangle Position')
%     xlabel('Time(sec)')
%     ylabel('Position(mm)')
%     
% end
% legend('X-Position','Y-Position','Z-Position');
% 
% %Graph end effector velocity
% figure
%  oldX  = out(1,4);
%  oldY  = out(1,5);
%  oldZ  = out(1,6);
%  oldTime = 0;
%  oldVX = 0;
%  oldVY = 0;
%  oldVZ = 0;
% for i = 1:size(out)
%     time = out(i,7);
%     %Select rows from csv matrix
%    
%     VX =  ((out(i,4) - oldX)/(time - oldTime));
%     VY = ((out(i,5) - oldY)/(time - oldTime));
%     VZ = ((out(i,6) - oldZ)/(time - oldTime));
%     
%     %Plot for joint angles
%     plot([(oldTime) time],[oldVX VX], 'r-', [(oldTime) time],[oldVY VY],'g-',[(oldTime) time],[oldVZ VZ],'b-');
%     
%     %Set labels for plot
%     if(i == 1)
%         title('End Effector Velocities');
%         xlabel('Time (sec)');
%         ylabel('Velocity (mm/sec)');
%     end
% 
%     
%     %Save value for line generation
%     oldX  = out(i,4);
%     oldY  = out(i,5);
%     oldZ  = out(i,6);
%     oldTime = time;
%     oldVX = VX;
%     oldVY = VY;
%     oldVZ = VZ;
%     hold on
%     grid on
% end 
% legend('X-Velocity','Y-Velocity','Z-Velocity');
% 
% 
% figure
% oldX  = out(1,4);
% oldY  = out(1,5);
% oldZ  = out(1,6);
% oldTime = 0;
% oldVX = 0;
% oldVY = 0;
% oldVZ = 0;
% oldAX = 0;
% oldAY = 0;
% oldAZ = 0;
% %Graph end effector acceleration
% for i = 1:size(out)
%     time = out(i,7);
%     %Select rows from csv matrix
%     VX =  ((out(i,4) - oldX)/(time - oldTime));
%     VY = ((out(i,5) - oldY)/(time - oldTime));
%     VZ = ((out(i,6) - oldZ)/(time - oldTime));
%     AX = (VX -oldVX)/(time - oldTime);
%     AY =  (VY -oldVY)/(time - oldTime);
%     AZ = (VZ -oldVZ)/(time - oldTime);
%     %Plot for end effector
%     plot([(oldTime) time],[oldAX AX], 'r-', [(oldTime) time],[oldAY AY],'g-',[(oldTime) time],[oldAZ AZ],'b-');
%     
%     %Set labels for plot
%     if(i == 1)
%         title('End Effector Acceleration');
%         xlabel('Time (sec)');
%         ylabel('Accleration (mm/sec^2)');
%        
%     end
%     
%     %Save value for line generation
%     oldX  = out(i,4);
%     oldY  = out(i,5);
%     oldZ  = out(i,6);
%     oldTime = time;
%     oldVX = VX;
%     oldVY = VY;
%     oldVZ = VZ;
%     oldAX = AX;
%     oldAY = AY;
%     oldAZ = AZ;
%     hold on
%     grid on
% end 
% legend('X-Acceleration','Y-Acceleration','Z-Acceleration');
pp.shutdown()