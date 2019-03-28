function threeD_vel_vector(pos, vel)
    L1 = 135; % [mm]
    L2 = 175; % [mm]
    L3 = 169.28; % [mm]
    T1 = tdh(0,90,L1,pos(1));
    T2 = T1 * tdh(L2,0,0,pos(2));
    T3 = T2 * tdh(L3,0,0,(pos(3)-90));
    plot3([0 T1(13)],[0 T1(14)], [0 T1(15)],'ro-', [T1(13) T2(13)],[T1(14) T2(14)],[T1(15) T2(15)],'go-',  [T2(13) T3(13)],[T2(14) T3(14)],[T2(15) T3(15)],'bo-', T3(13),T3(14),T3(15), 'r.');
    hold on
    quiver3(T3(13),T3(14),T3(15),vel(1), vel(2), vel(3));
    hold off
    grid on
    title('3D Plot of Arm Position')
    xlabel('X-axis (mm)')
    ylabel('Y-axis (mm)')
    zlabel('Z-axis (mm)')
    axis([-500 500 -500 500 0 500]);
%     view([180 90]);
%     view([-4.418 -1.633 2.588]);
    
end