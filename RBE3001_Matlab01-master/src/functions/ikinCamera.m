function angles = ikin(V)
    L1 = 135; %[mm]
    L2 = 175; %[mm]
    L3 = 169.28; %[mm]
    
    X = V(1);
    Y = V(2);
    Z = V(3);
    
    H = sqrt((X)^2 + (Y)^2); 
    L4 = sqrt((H)^2 + (Z-L1)^2); 
    
    alpha= acosd(((L3)^2 - (L2)^2 - (L4)^2)/(2*L4*L2));
    beta =  atan2d(Z-L1, H);
    
    theta0 = atan2d(-1 * Y,X)
    theta1 = 180 - (alpha - beta)
    theta2 = -1 *(acosd(((L4)^2 - (L2)^2 - (L3)^2)/(2*L3*L2)) - 90)
    
    
    if (theta0 < -85) || (theta0 > 85)
        error('theta0 is out of bounds');
    end
    if (theta1 < -7.5) || (theta1 > 100)
        error('theta1 is out of bounds');
    end
    if (theta2 < -27.6) || (theta2 > 213)
        error('theta2 is out of bounds');  
    end 
    if (X-(X-L2))^2 + (Y-0)^2 + (Z-L1) ^ 2 > (L2+L3)^2
        error('End effector position out of workspace');
    end
    angles = [theta0; theta1; theta2];
end