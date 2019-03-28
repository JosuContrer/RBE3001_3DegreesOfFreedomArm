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

setPID(0.001, 0.0001, 0.01, ...
        0.009, 0.0001, 0.06, ...
        0.001, 0.0001, 0.01, ...
        pp, PIDCONFIG_SERV_ID);

anglesi = [0,0,0];
angles = [0,0,0];
while 1
    y = 0;
    axis([-250 600 -100 500]);
    grid on
    xlabel('X-axis (mm)')    
    ylabel('Z-axis (mm)')
    [x,z] = ginput(1);
    disp(x)
    disp(z)
    angles = ikin([(x-175),y,z]);

    %define variables
    J1_t0 = 0;
    J1_t1 = 16;
    J1_v0 = 0;
    J1_v1 = 0;
    J1_p0 = anglesi(2);
    J1_p1 = angles(2);

    J2_t0 = 0;
    J2_t1 = 16;
    J2_v0 = 0;
    J2_v1 = 0;
    J2_p0 = anglesi(3);
    J2_p1 = angles(3);

    %First movement
    J1_a = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
    J2_a = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);
    %figure()
    hold off
    t = 0;
    while t <= 16
        J1_setPoint = ((J1_a(1)) + (J1_a(2)*t) + (J1_a(3)*t^2) + (J1_a(4)*t^3));
        J2_setPoint = ((J2_a(1)) + (J2_a(2)*t) + (J2_a(3)*t^2) + (J2_a(4)*t^3));
        moveArmAngles(0, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
        angles = readArm(pp, STATUS_SERV_ID);
        threeD_joint_plot(angles);
        hold on
        plot3(x, y, z, 'go');
        %hold off
        view(0, 0);
        t = t + 1;
        pause(.2);
    end
    anglesi = angles;
    close all
end