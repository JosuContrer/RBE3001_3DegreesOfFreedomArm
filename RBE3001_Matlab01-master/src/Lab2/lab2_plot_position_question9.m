%
%Trajectory Generation Question #7
%   In this file our team used logged data to create a plot wiht three
%   lines representing the joint angles (in degrees) vs time (in sec) 
%   and another plot with two lines representing x & z tip positions 
%   (in mm) vs time (in sec).

clc
clear

%open csv file and put it iin matrix form
fid = 'lab2_values_question9.csv';
out = csvread(fid);


%plot set points
plot(out(2750, 4), out(2750,5), 'mo', out(1720, 4), out(1720,5), 'bo', out(3588, 4), out(3588,5), 'go');
hold on
%variables for plotting line
endX = out(1,4);
endY = out(1,5);

%plot for endefector
for i = 2:size(out)   
    %plot for endefector
    time = out(i,7);
    plot([endX out(i,4)],[endY out(i,5)], 'r-');
 
    %Save value for line generation
    endX = out(i,4);
    endY = out(i,5);
    grid on
end

%Set labels for plot
title('Endefector Position');
xlabel('X (mm)');
ylabel('Y (mm)');
hold off