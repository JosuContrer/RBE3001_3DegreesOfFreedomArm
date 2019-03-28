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

%Set labels for plot
title('Endefector Position');
xlabel('X (mm)');
ylabel('Y (mm)');

%plot set points
plot(out(35, 4), out(35,5), 'mo', out(981, 4), out(981,5), 'bo', out(1300, 4), out(1300,5), 'go');
hold on
%variables for plotting line
endX = out(35,4);
endY = out(35,5);

%plot for endefector
for i = 36:size(out)   
    %plot for endefector
    time = out(i,7);
    plot([endX out(i,4)],[endY out(i,5)], 'r-');
 
    %Save value for line generation
    endX = out(i,4);
    endY = out(i,5);
    grid on
end