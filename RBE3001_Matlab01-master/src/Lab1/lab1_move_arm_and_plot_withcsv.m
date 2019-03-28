% setpoint commands and receive sensor data.
% 
% IMPORTANT - understanding the code below requires being familiar
% with the Nucleo firmware. Read that code first.
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

%open csv file
fid = fopen('lab1_testValues.csv','w');

%Debug mode?
DEBUG = true;


%Define Variables
count = 0;
lastToc = 0;
lastAngles = [ 0 0 0 ];
%Send PID values to PIDConfigServer
setPID(0.001, 0.0001, 0.01);

%Plot setup
figure
title('Angle of Joints')
xlabel('Time(tics)')
ylabel('Angle(Degrees)')
hold on
grid on
tic %start timer

while count < 1
    readCount = 0;
    moveArm(-400, 200,200); 
 
    while readCount < 120
        angles = readArm(fid);
        disp(angles(1));
        plot([lastToc toc], [lastAngles(1) angles(1)], 'r-', [lastToc toc], [lastAngles(2) angles(2)], 'g-', [lastToc toc], [lastAngles(3) angles(3)], 'b-');
        lastToc = toc;
        lastAngles = angles;
        readCount = readCount + 1;
    end
    readCount = 0;
    
    moveArm(400, 600,-200);

    while readCount < 120
        angles = readArm(fid);
        disp(angles(1));
        plot([lastToc toc], [lastAngles(1) angles(1)], 'r-', [lastToc toc], [lastAngles(2) angles(2)], 'g-', [lastToc toc], [lastAngles(3) angles(3)], 'b-');
        lastToc = toc;
        lastAngles = angles;
        readCount = readCount + 1;
    end
    readCount = 0
    moveArm(0, 800, 0);

    while readCount < 120
        angles = readArm(fid);
        disp(angles(1));
        plot([lastToc toc], [lastAngles(1) angles(1)], 'r-', [lastToc toc], [lastAngles(2) angles(2)], 'g-', [lastToc toc], [lastAngles(3) angles(3)], 'b-');
        lastToc = toc;
        lastAngles = angles;
        readCount = readCount + 1;
    end
    readCount = 0
    moveArm(200, 200, 200);

    while readCount < 120
        angles = readArm(fid);
        disp(angles(1));
        plot([lastToc toc], [lastAngles(1) angles(1)], 'r-', [lastToc toc], [lastAngles(2) angles(2)], 'g-', [lastToc toc], [lastAngles(3) angles(3)], 'b-');
        lastToc = toc;
        lastAngles = angles;
        readCount = readCount + 1;
    end
   
    count = count + 1;
end

% Close csv file
fclose(fid);
% Clear up memory upon termination 
pp.shutdown();


%Function to send PID values to PIDConfigServe
function setPID(Kp, Ki, Kd)
    global PIDCONFIG_SERV_ID;
    global pp;
    packet = zeros(15, 1, 'single'); %create empty packet

    for x = 0:3
        packet((x*3)+1) = Kp;
        packet((x*3)+2) = Ki;
        packet((x*3)+3) = Kd; 
    end
    pp.write(PIDCONFIG_SERV_ID, packet); %send packet
    pause(0.003);
    fprintf('Return Packet from PIDCONFIG_SERV:\n');
    fprintf('%d\n', pp.read(PIDCONFIG_SERV_ID)); %read packet and print
end

%Function to move arm
function moveArm(joint0, joint1, joint2)
    global PID_SERV_ID;    
    global pp;
    packet = zeros(15,1,'single');
    packet(1) = joint0;
    packet(4) = joint1;
    packet(7) = joint2;
    pp.write(PID_SERV_ID, packet);
    pause(0.003);
    fprintf('Return Packet from PID_SERV:\n');
    fprintf('%d\n',pp.read(PID_SERV_ID));
end

%Function to read position of joints (in degrees)
function angles = readArm(fidp)
    global STATUS_SERV_ID;    
    global pp;
    packet = zeros(15,1,'single');
    pp.write(STATUS_SERV_ID, packet); %send status server an empty packet
    pause(0.003);
    returnPacket = pp.read(STATUS_SERV_ID); %read packet from status server
    angles = [returnPacket(1), returnPacket(4), returnPacket(7)];
    
    %Write encoder values to a csv file
    %if(~(returnPacket(1) == previousPacket1 && returnPacket(4) == previousPacket4 && returnPacket(7) == previousPacket7))
        fprintf(fidp, '%d, %d, %d, %d \n', returnPacket(1), returnPacket(4), returnPacket(7), toc);
    %end
    
    %Convert encoder values to angles
    angles = ((angles/4096)*360);
    fprintf('Return Packet from STATUS_SERV:\n');
    fprintf('%d\n',returnPacket);
end

