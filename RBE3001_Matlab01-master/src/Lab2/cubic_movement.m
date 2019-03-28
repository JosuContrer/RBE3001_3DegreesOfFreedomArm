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
fid = fopen('lab2_values_question9.csv','w');

%Define Server Numbers
global PID_SERV_ID;
global PIDCONFIG_SERV_ID;
global STATUS_SERV_ID;
PID_SERV_ID = 01;
PIDCONFIG_SERV_ID= 02;
STATUS_SERV_ID = 03;

%Send PID values to PIDConfigServer
setPID(0.001, 0.0001, 0.01, ...
        0.009, 0.0001, 0.06, ...
        0.001, 0.0001, 0.01, ...
        pp, PIDCONFIG_SERV_ID);

%define variables
J1_t0 = 0;
J1_t1 = 8;
J1_v0 = 0;
J1_v1 = 0;
J1_p0 = 0;
J1_p1 = 70.074;

J2_t0 = 0;
J2_t1 = 8;
J2_v0 = 0;
J2_v1 = 0;
J2_p0 = 0;
J2_p1 = -34.8161;

t = 0;
%First movement
J1_a = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_a = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);

tic
while t <= 8
    t = toc;
    J1_setPoint = ((J1_a(1)) + (J1_a(2)*t) + (J1_a(3)*t^2) + (J1_a(4)*t^3));
    J2_setPoint = ((J2_a(1)) + (J2_a(2)*t) + (J2_a(3)*t^2) + (J2_a(4)*t^3));
    moveArmAngles(0, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);
end

%Second Movement
J1_t0 = 8;
J1_t1 = 16;
J1_v0 = 0;
J1_v1 = 0;
J1_p0 = 70.074;
J1_p1 = 96.721;

J2_t0 = 8;
J2_t1 = 16;
J2_v0 = 0;
J2_v1 = 0;
J2_p0 = -34.8161;
J2_p1 = -34.5305;

t = 0;

J1_a = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_a = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);

while t <= 16
    t = toc;
    J1_setPoint = ((J1_a(1)) + (J1_a(2)*t) + (J1_a(3)*t^2) + (J1_a(4)*t^3));
    J2_setPoint = ((J2_a(1)) + (J2_a(2)*t) + (J2_a(3)*t^2) + (J2_a(4)*t^3));
    moveArmAngles(0, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);

end

%Third Movement
J1_t0 = 16;
J1_t1 = 24;
J1_v0 = 0;
J1_v1 = 0;
J1_p0 = 96.721;
J1_p1 = 70.0462;

J2_t0 = 16;
J2_t1 = 24;
J2_v0 = 0;
J2_v1 = 0;
J2_p0 = -34.5305;
J2_p1 = -6.3835;

t = 0;

J1_a = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_a = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);


while t <= 24
    t = toc;
    J1_setPoint = ((J1_a(1)) + (J1_a(2)*t) + (J1_a(3)*t^2) + (J1_a(4)*t^3));
    J2_setPoint = ((J2_a(1)) + (J2_a(2)*t) + (J2_a(3)*t^2) + (J2_a(4)*t^3));
    moveArmAngles(0, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);

end

%Fourth Movement
J1_t0 = 24;
J1_t1 = 32;
J1_v0 = 0;
J1_v1 = 0;
J1_p0 = 70.0462;
J1_p1 = 70.074;

J2_t0 = 24;
J2_t1 = 32;
J2_v0 = 0;
J2_v1 = 0;
J2_p0 = -6.3835;
J2_p1 = -34.8161;

t = 0;

J1_a = cubic(J1_t0, J1_t1, J1_v0, J1_v1, J1_p0, J1_p1);
J2_a = cubic(J2_t0, J2_t1, J2_v0, J2_v1, J2_p0, J2_p1);

while t <= 32
    t = toc;
    J1_setPoint = ((J1_a(1)) + (J1_a(2)*t) + (J1_a(3)*t^2) + (J1_a(4)*t^3));
    J2_setPoint = ((J2_a(1)) + (J2_a(2)*t) + (J2_a(3)*t^2) + (J2_a(4)*t^3));
    moveArmAngles(0, J1_setPoint, J2_setPoint, pp, PID_SERV_ID);
    angles = readArm(pp, STATUS_SERV_ID);
    T = fwkin3001(angles);
    fprintf(fid, '%d, %d, %d, %d, %d, %d, %d\n',angles(1),angles(2),angles(3),T(1),T(2),T(3), toc);

end

pp.shutdown()