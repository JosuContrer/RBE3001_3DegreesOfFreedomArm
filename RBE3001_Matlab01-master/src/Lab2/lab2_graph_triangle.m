%
%Trajectory Generation Question #7
%   In this file our team used logged data to create a plot wiht three
%   lines representing the joint angles (in degrees) vs time (in sec) 
%   and another plot with two lines representing x & z tip positions 
%   (in mm) vs time (in sec).

clc
clear

%open csv file and put it iin matrix form
fid = 'lab2_values_question7.csv';
out = csvread(fid);

%variables for plotting line
oldJ0 = 0;
oldJ1 = 0;
oldJ2 = 0;
endX = 0;
endZ = 0;
oldTime = 0;
oldV0 = 0;
oldV1 = 0;
oldV2 = 0;

%Plot for joint angles
for i = 1:size(out)
    
    %Select rows from csv matrix
    subplot(3,1,1);
    J0 = out(i,1);
    J1 = out(i,2);
    J2 = out(i,3);
    time = out(i,7);
    
    %Plot for joint angles
    plot([(oldTime) time],[oldJ0 J0], 'r-', [(oldTime) time],[oldJ1 J1],'g-',[(oldTime) time],[oldJ2 J2],'b-');
    
    %Set labels for plot
    if(i == 1)
        title('Joint Angles');
        xlabel('Time (sec)');
        ylabel('Angle (degrees)');
    end
    
    %Save value for line generation
    oldJ0 = out(i,1);
    oldJ1 = out(i,2);
    oldJ2 = out(i,3);
    oldTime = out(i,7);
    hold on
    grid on
end 
legend('Joint0','Joint1','Joint2');

oldTime = 0;

%Plot for joint angular velocities 
for i = 1:size(out)
    
    %Select rows from csv matrix
    subplot(3,1,2);
    J0 = out(i,1);
    J1 = out(i,2);
    J2 = out(i,3);
    time = out(i,7);
    V0 =  ((J0 - oldJ0)/(time - oldTime));
    V1 = ((J1 - oldJ1)/(time - oldTime));
    V2 = ((J2 - oldJ2)/(time - oldTime));
    
    %Plot for joint angles
    plot([(oldTime) time],[oldV0 V0], 'r-', [(oldTime) time],[oldV1 V1],'g-',[(oldTime) time],[oldV2 V2],'b-');
    
    %Set labels for plot
    if(i == 1)
        title('Joint Angular Velocities');
        xlabel('Time (sec)');
        ylabel('Velocity (degrees/sec)');
        axis([0 8 -200 200])
    end
    
    %Save value for line generation
    oldJ0 = out(i,1);
    oldJ1 = out(i,2);
    oldJ2 = out(i,3);
    oldTime = out(i,7);
    oldV0 = V0;
    oldV1 = V1;
    oldV2 = V2;
    hold on
    grid on
end 
legend('Joint0','Joint1','Joint2');

oldTime = 0;
%plot for endefector
for i = 1:size(out)   
    %plot for endefector
    time = out(i,7);
    subplot(3,1,3) 
    plot([(oldTime) time],[endX out(i,4)], 'r-',[(oldTime) time],[endZ out(i,6)],'g-');
    
    %Set labels for plot
    if(i ==1)
        title('Endefector Position');
        xlabel('Time (sec)');
        ylabel('Postion (mm)');
    end

    %Save value for line generation
    endX = out(i,4);
    endZ = out(i,6);
    oldTime = out(i,7);
    hold on
    grid on
end

%legends for the two plots
legend('X-Axis','Z-Axis');
