%Function to move gripper
function moveGripper(setPoint, pp, SERVO_SERV_ID)   
    packet = zeros(15,1,'single');
    packet(1) = setPoint;
    pp.write(SERVO_SERV_ID, packet);
    pause(0.003);
    fprintf('Return Packet from SERVO_SERV:\n');
    fprintf('%d\n',pp.read(SERVO_SERV_ID));
end