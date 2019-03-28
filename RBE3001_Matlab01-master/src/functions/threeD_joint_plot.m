function threeD_joint_plot(q)
    L1 = 135; % [mm]
    L2 = 175; % [mm]
    L3 = 169.28; % [mm]
    T1 = tdh(0,90,L1,q(1));
    T2 = T1 * tdh(L2,0,0,q(2));
    T3 = T2 * tdh(L3,0,0,(q(3)-90));
    plot3([0 T1(13)],[0 T1(14)], [0 T1(15)],'ro-', [T1(13) T2(13)],[T1(14) T2(14)],[T1(15) T2(15)],'go-',  [T2(13) T3(13)],[T2(14) T3(14)],[T2(15) T3(15)],'bo-', T3(13),T3(14),T3(15), 'r.');
    %plot3(T(1,:), T(2,:), T(3,:), 'r-');
    grid on
    title('3D Plot of Arm Position')
    xlabel('X-axis (mm)')
    ylabel('Y-axis (mm)')
    zlabel('Z-axis (mm)')
    axis([-250 600 -250 250 -100 500]);
    
    
end