function J = jacob0(theta1, theta2, theta3)
    L1 = 135; % [mm]
    L2 = 175; % [mm]
    L3 = 169.28; % [mm]
    
    J = [(-1*L2*sind(theta1)*cosd(theta2)-L3*cosd(theta3 - 90)*sind(theta1)*cosd(theta2)+L3*sind(theta3 -90)*sind(theta1)*sind(theta2)) (-1*L2*cosd(theta1)*sind(theta2) -L3*cosd(theta3 -90)*cosd(theta1)*sind(theta2)-L3*sind(theta3 - 90)*cosd(theta1)*cosd(theta2)) (-1*L3*sind(theta3-90)*cosd(theta1)*cosd(theta2)-L3*cosd(theta3-90)*cosd(theta1)*sind(theta2));
        (L2*cosd(theta2)*cosd(theta1)+L3*cosd(theta3-90)*cosd(theta2)*cosd(theta1)-L3*sind(theta3-90)*cosd(theta1)*sind(theta2)) -1*L2*sind(theta2)*sind(theta1)-L3*cosd(theta3-90)*sind(theta2)*sind(theta1)-L3*sind(theta3-90)*sind(theta1)*cosd(theta2) -1*L3*sind(theta3-90)*cosd(theta2)*sind(theta1)-L3*cosd(theta3-90)*sind(theta1)*sind(theta2);
        0 L2*cosd(theta2)+L3*cosd(theta3-90)*cosd(theta2)-L3*sind(theta3-90)*sind(theta2) -L3*sind(theta3-90)*sind(theta2)+L3*cosd(theta3-90)*cosd(theta2);
        0 sind(theta1) sind(theta1);
        0 -1*cosd(theta1) -1*cosd(theta1);
        1 0 0];
        
end