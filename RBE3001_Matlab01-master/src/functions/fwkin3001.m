%%
% fwkin3001 FUNCTION

%%
% Function fwkin3001() 

% Function fwkinscara that implements the forward kinematics.

function T = fwkin3001(q)
    %q is a 3x1 vector containing the generalized joint variables
    L1 = 135; % [mm]
    L2 = 175; % [mm]
    L3 = 169.28; % [mm]
    
    %defined a, d, and alpha for the loop
    ak = [0 L2 L3];
    dk = [L1 0 0];
    alpha = [90 0 0];
    
    t1 = tdh(ak(1), alpha(1), dk(1), q(1));
    t2 = tdh(ak(2), alpha(2), dk(2), q(2));
    t3 = tdh(ak(3), alpha(3), dk(3), q(3)-90);
    
%     t1 = tdh(q(1), dk(1), alpha(1), ak(1));
%     t2 = tdh(q(2), dk(2), alpha(2), ak(2));
%     t3 = tdh(q(3)-90, dk(3), alpha(3), ak(3));
    
    H = t1*t2*t3;
    
    T = [H(13) H(14) H(15)];
    
end