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

%define variables
J0 = 0;
J1 = 0;
J2 = 0;
count = 0;

%open csv file
fid = fopen('lab2_calibration_values.csv','w');

tic %start stopwatch
while count < 11
    M = readArmTicks(fid, pp, STATUS_SERV_ID);
    pause(1);
    J0 = J0 + M(1);
    J1 = J1 + M(2);
    J2 = J2 + M(3);
    count = count + 1;
end

avg = [J0/10 J1/10 J2/10]

pp.shutdown()

