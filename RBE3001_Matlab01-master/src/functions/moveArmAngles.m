%Function to move arm (angle input)
function moveArmAngles(joint0, joint1, joint2, pp, PID_SERV_ID)   
    packet = zeros(15,1,'single');
    packet(1) = (joint0/360)*4096;
    packet(4) = (joint1/360)*4096;
    packet(7) = (joint2/360)*4096;
    pp.write(PID_SERV_ID, packet);
    pause(0.003);
    fprintf('Return Packet from PID_SERV:\n');
    fprintf('%d\n',pp.read(PID_SERV_ID));
end