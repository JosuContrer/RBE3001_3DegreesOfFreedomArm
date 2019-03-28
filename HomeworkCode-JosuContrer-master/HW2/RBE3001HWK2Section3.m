% RBE 3001 HWK 2 Section 3: MatLab programming
% Josue Contreras
clc
clear

%%
% Question # 7
% Function trotz() takes as input the values of an angle theta and returns
% a 4x4 homogeneous transformation matrix representing rotation about the Z
% axis by that angle. Analogously, function troty() and trotx() do the same
% computation.

function T = trotz(theta)
    T = [cos(theta) -sin(theta) 0 0; 
        sin(theta) cos(theta) 0 0; 
        0 0 1 0; 
        0 0 0 1];
end

function T = troty(theta)
    T = [cos(theta) 0 sin(theta) 0; 
        0 1 0 0; 
        -sin(theta) 0 cos(theta) 0; 
        0 0 0 1];
end

function T = trotx(theta)
    T = [1 0 0 0; 
        0 cos(theta) -sin(theta) 0; 
        0 sin(theta) cos(theta) 0; 
        0 0 0 1];
end

%%
% Question # 8
% Function tdh() takes as input the DH parameters of a robotic link and
% returns the 4x4 homogeneous transformation matrix between the two
% corresponding joints.

function T = tdh(theta, d, alpha, a)
    T = [cos(theta) -sin(theta)*cos(alpha) sin(theta)*sin(alpha) a*cos(theta);
        sin(theta) cos(theta)*cos(alpha) -cos(theta)*sin(alpha) a*sin(theta);
        0 sin(alpha) cos(alpha) d;
        0 0 0 1];
end

%%
% Question # 9
% Function fwkinscara that implements the forward kinematics for the SCARA
% manipulator pictured in Figure 2 on hwk 2.

function T = fwkinscara(q)
    %q is a 4x1 vector containing the generalized joint variables
    L1 = 0.5; % [m]
    L2 = 0.5; % [m]
    L3 = 0.2; % [m]
    L4 = 0.1; % [m]
    
    %defined a, d, and alpha for the loop
    ak = [0 0 L1 L2];
    dk = [L3 L4 0 0];
    alpha = [0 0 -pi 0];
    
    %for i = 1:size(q,1)
        t1 = tdh(q(1,1), dk(1,1), alpha(1,1), ak(1,1));
        t2 = tdh(q(2,1), dk(1,2), alpha(1,2), ak(1,2));
        t3 = tdh(q(3,1), dk(1,3), alpha(1,3), ak(1,3));
        t4 = tdh(q(4,1), dk(1,4), alpha(1,4), ak(1,4));
        
        T = t1*t2*t3*t4
    %end
    
end
