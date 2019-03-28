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
fid = fopen('lab3_time_histogram.csv','w');
count = 1;
oldToc = 0;
tic
while count <= 500
packet = zeros(15,1,'single');
pp.write(STATUS_SERV_ID, packet); %send status server an empty packet
pause(0.003);
returnPacket = pp.read(STATUS_SERV_ID); %read packet from status server
fprintf(fid, ' %d\n',toc - oldToc);
oldToc = toc;
count = count + 1;
end
pp.shutdown();

out = csvread('lab3_time_histogram.csv');
group = [3.5:.01:5].*(10^-3); 
histogram(out, group);
title('Packet Communication Time Delay');
xlabel('Time (ms)');
ylabel('Received Packets');
%Matrix that gives average, standard deviation, min, and max in that order
statistics = [mean(out) std(out) min(out) max(out)] 