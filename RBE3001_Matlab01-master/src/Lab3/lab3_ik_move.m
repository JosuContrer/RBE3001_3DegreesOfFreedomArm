addpath(strcat(userpath, '/functions'));
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
fid = fopen('lab3_values_question3.csv','w');

setPID(0.001, 0.0001, 0.01, pp, PIDCONFIG_SERV_ID);

% angles = ikin([-100 100 60]);
% moveArmAngles(angles(1),angles(2),angles(3),pp,PID_SERV_ID);

count = 0;
tic
while  count < 2
    readCount = 0;
    angles = ikin([0 0 0])
    moveArmAngles(angles(1),angles(2),angles(3),pp,PID_SERV_ID);
    while readCount < 200
        readCount = readCount + 1;
        readAngles = readArm(pp, STATUS_SERV_ID);
        T = fwkin3001(readAngles);
        threeD_joint_plot(readAngles);
        fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',readAngles(1),readAngles(2),readAngles(3),T(1),T(2),T(3), toc);
    end
    
    readCount = 0;
    angles = ikin([-50 -200 200]);
    moveArmAngles(angles(1),angles(2),angles(3),pp,PID_SERV_ID);
    while readCount < 200
        readCount = readCount + 1;
        readAngles = readArm(pp, STATUS_SERV_ID);
        T = fwkin3001(readAngles);
        threeD_joint_plot(readAngles);
        fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',readAngles(1),readAngles(2),readAngles(3),T(1),T(2),T(3), toc);
    end
    
    
    readCount = 0;
    angles = ikin([0 0 0])
    moveArmAngles(angles(1),angles(2),angles(3),pp,PID_SERV_ID);
    while readCount < 200
        readCount = readCount + 1;
        readAngles = readArm(pp, STATUS_SERV_ID);
        T = fwkin3001(readAngles);
        threeD_joint_plot(readAngles);
        fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',readAngles(1),readAngles(2),readAngles(3),T(1),T(2),T(3), toc);
    end
    
    readCount = 0;
    angles = ikin([-100 100 60])
    moveArmAngles(angles(1),angles(2),angles(3),pp,PID_SERV_ID);
    while readCount < 200
        readCount = readCount + 1;
        readAngles = readArm(pp, STATUS_SERV_ID);
        T = fwkin3001(readAngles);
        threeD_joint_plot(readAngles);
        fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',readAngles(1),readAngles(2),readAngles(3),T(1),T(2),T(3), toc);
    end
    count = count + 1;
end
pause(.3);
pp.shutdown();