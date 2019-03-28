%Function to read velocity of joints (in degrees/s)
function velocities = readArmVel(pp, STATUS_SERV_ID)
    packet = zeros(15,1,'single');
    pp.write(STATUS_SERV_ID, packet); %send status server an empty packet
    pause(0.003);
    returnPacket = pp.read(STATUS_SERV_ID); %read packet from status server
    velocities = [returnPacket(2), returnPacket(5), returnPacket(8)];
    
    %Convert encoder values to angles
    velocities = ((velocities/4096)*360);
    fprintf('Return Packet from STATUS_SERV:\n');
    fprintf('%d\n',returnPacket);
end