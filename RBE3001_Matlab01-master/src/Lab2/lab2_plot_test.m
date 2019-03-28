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
count = 0;

setPID(0.001, 0.0001, 0.01, ...
        0.009, 0.0001, 0.06, ...
        0.001, 0.0001, 0.01, ...
        pp, PIDCONFIG_SERV_ID);
    
%test plotting
tic %start timer
while count < 4
    readCount = 0;
    moveArm(-400, 200, 200, pp, PID_SERV_ID); 
 
    while readCount < 120
        angles = readArm(pp, STATUS_SERV_ID);
        threeD_joint_plot(angles);
        readCount = readCount + 1;
    end
    readCount = 0;
    
    moveArm(400, 600,-200,pp,PID_SERV_ID);

    while readCount < 120
        angles = readArm(pp, STATUS_SERV_ID);
        threeD_joint_plot(angles);
        readCount = readCount + 1;
    end
    readCount = 0;
    moveArm(0, 800, 0, pp, PID_SERV_ID);

    while readCount < 120
        angles = readArm(pp, STATUS_SERV_ID);
        threeD_joint_plot(angles);
        readCount = readCount + 1;
    end
    readCount = 0;
    moveArm(200, 200, 200, pp, PID_SERV_ID);

    while readCount < 120
        angles = readArm(pp, STATUS_SERV_ID);
        threeD_joint_plot(angles);
        readCount = readCount + 1;
    end
    readCount = 0;
    moveArm(600, 400, 600, pp, PID_SERV_ID);
    while readCount < 120
         angles = readArm(pp, STATUS_SERV_ID);
        threeD_joint_plot(angles);
        readCount = readCount + 1;
    end
   
    count = count + 1;
end


pp.shutdown();