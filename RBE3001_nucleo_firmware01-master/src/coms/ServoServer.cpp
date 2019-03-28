

/**
 * RBE3001 - Nucleo Firmware
 * See header file for more detail on this class.
 */
#include "ServoServer.h"
#include "Servo.h"
#define GRIPPER_SERVO PB_10
/**
 *  @brief This function handles incoming HID packets from MATLAB.
 *
 *  @description This method has two parts: in part 1, we will decode the incoming
 *               packet, extract the setpoints and send those values to the
 *               PID controller; in part 2, we will generate a response that will be
 *               sent back to MATLAB through HID. This is useful to e.g. send sensor
 *               data to MATLAB for plotting.
 */
void ServoServer::event(float * packet){

  /*
   * ======= PART 1: Decode setpoints and send commands to the PID controller ==
   */

  bool skipLink = false; //!FIXME Do we need this? If not, let's get rid of it


      // extract the three setpoint values (one for each joint) from the packet buffer
  float setpoint = packet[0];

  Servo myservo(GRIPPER_SERVO, 20);

  myservo = setpoint/100.0;
  wait(0.01);


  /*
   * ======= PART 2: Generate a response to be sent back to MATLAB =============
   */

  // we will be using the same memory area in which the incoming packet was stored,
  // however, a we need to perform a type cast first (for convenience).
  uint8_t * buff = (uint8_t *) packet;

  // re-initialize the packet to all zeros
  for (int i = 0; i < 60; i++){
      buff[i] = 0;

    }
}
