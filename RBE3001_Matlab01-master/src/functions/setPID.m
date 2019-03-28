%Function to send PID values to PIDConfigServe
function setPID(Kp0, Ki0, Kd0,Kp1, Ki1, Kd1,Kp2, Ki2, Kd2, pp, PIDCONFIG_SERV_ID)
    packet = zeros(15, 1, 'single'); %create empty packet

   
    packet((0*3)+1) = Kp0;
    packet((0*3)+2) = Ki0;
    packet((0*3)+3) = Kd0; 
    
    packet((1*3)+1) = Kp1;
    packet((1*3)+2) = Ki1;
    packet((1*3)+3) = Kd1; 
    
    packet((2*3)+1) = Kp2;
    packet((2*3)+2) = Ki2;
    packet((2*3)+3) = Kd2; 
    
    pp.write(PIDCONFIG_SERV_ID, packet); %send packet
    pause(0.003);
    fprintf('Return Packet from PIDCONFIG_SERV:\n');
    fprintf('%d\n', pp.read(PIDCONFIG_SERV_ID)); %read packet and print
end