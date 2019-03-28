%% Quintic Polynomial - Lab3 Question 7
% Written by Team 1 2019

% Function quintic()
% INPUTS: inital & final time, inital & final velocities, initial & final positions
% inital & final accelerations 
% RETURNS: coefficients of quintic polynomial

% Quintic polynomial for a smoother trajectory movement
function A = quintic(t0, t1, a0, a1, v0, v1, p0, p1)
    M = [1 t0 t0^2 t0^3 t0^4 t0^5;
        0 1 (2*t0) (3*t0^2) (4*t0^3) (5*t0^4);
        0 0 2 (6*t0) (12*t0^2) (20*t0^3);
        1 t1 (t1^2) (t1^3) (t1^4) (t1^5);
        0 1 (2*t1) (3*t1^2) (4*t1^3) (5*t1^4);
        0 0 2 (6*t1) (12*t1^2) (20*t1^3)];
    
    A = M \ [p0; v0; a0; p1; v1; a1];
end
