%Function to read position of joints (in degrees)
function angles = readArmTicks(fidp, pp, STATUS_SERV_ID)   
    packet = zeros(15,1,'single');
    pp.write(STATUS_SERV_ID, packet); %send status server an empty packet
    pause(0.003);
    returnPacket = pp.read(STATUS_SERV_ID); %read packet from status server
    angles = [returnPacket(1), returnPacket(4), returnPacket(7)];
    
    %Write encoder values to a csv file
    %if(~(returnPacket(1) == previousPacket1 && returnPacket(4) == previousPacket4 && returnPacket(7) == previousPacket7))
        fprintf(fidp, '%d, %d, %d, %d \n', returnPacket(1), returnPacket(4), returnPacket(7), toc);
    %end
    
    %Convert encoder values to angles
    %angles = ((angles/4096)*360);
    fprintf('Return Packet from STATUS_SERV:\n');
    fprintf('%d\n',returnPacket);
end