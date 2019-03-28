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

%open cs file
fid = fopen('lab2_values_question7.csv','w');

%Define Server Numbers
global PID_SERV_ID;
global PIDCONFIG_SERV_ID;
global STATUS_SERV_ID;
PID_SERV_ID = 01;
PIDCONFIG_SERV_ID= 02;
STATUS_SERV_ID = 03;

count = 0;
setPID(0.001, 0.0001, 0.01, pp, PIDCONFIG_SERV_ID);


angles = [0 0 0];
T = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];

readCount = 0;
tic;
moveArmAngles(0, 70.074, -34.8161, pp, PID_SERV_ID); 
while readCount < 500
    readCount = readCount + 1;
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
end
readCount = 0;

moveArmAngles(0, 96.721, -34.5305, pp, PID_SERV_ID);
while readCount < 500
    readCount = readCount + 1;
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
end
readCount = 0;

moveArmAngles(0, 70.0462, -6.3835, pp, PID_SERV_ID);
while readCount < 500
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
    readCount = readCount + 1;
end
readCount = 0;

moveArmAngles(0, 70.074, -34.8161, pp, PID_SERV_ID); 
while readCount < 500
    readCount = readCount + 1;
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
end
%Close cvs file
fclose(fid)


pp.shutdown()