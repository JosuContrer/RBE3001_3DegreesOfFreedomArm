%%
% TDH FUNCTION

%%
% Function tdh() takes as input the DH parameters of a robotic link and
% returns the 4x4 homogeneous transformation matrix between the two
% corresponding joints.

function T = tdh(a, alpha, d, theta)
    T = [cosd(theta) -sind(theta)*cosd(alpha) sind(theta)*sind(alpha) a*cosd(theta);
        sind(theta) cosd(theta)*cosd(alpha) -cos(theta)*sind(alpha) a*sind(theta);
        0 sind(alpha) cosd(alpha) d;
        0 0 0 1];
end