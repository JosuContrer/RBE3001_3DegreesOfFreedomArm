%Function to move arm (ticks)
function moveArm(joint0, joint1, joint2, pp, PID_SERV_ID)   
    packet = zeros(15,1,'single');
    packet(1) = joint0;
    packet(4) = joint1;
    packet(7) = joint2;
    pp.write(PID_SERV_ID, packet);
    pause(0.003);
    fprintf('Return Packet from PID_SERV:\n');
    fprintf('%d\n',pp.read(PID_SERV_ID));
end