/*
 * StatusServer.cpp
 *
 *  Created on: Jan 18, 2019
 *      Author: tarizzo
 */

#include "StatusServer.h"

/**
 *  @brief This function handles incoming HID packets from MATLAB.
 *
 *  @description This method has two parts: in part 1, we will decode the incoming
 *               packet, extract the setpoints and send those values to the
 *               Status controller; in part 2, we will generate a response that will be
 *               sent back to MATLAB through HID. This is useful to e.g. send sensor
 *               data to MATLAB for plotting.
 */
void StatusServer::event(float * packet){


  /*
   * ======= Generate a response to be sent back to MATLAB =============
   */

  // we will be using the same memory area in which the incoming packet was stored,
  // however, a we need to perform a type cast first (for convenience).
  uint8_t * buff = (uint8_t *) packet;
  // re-initialize the packet to all zeros
  for (int i = 0; i < 60; i++){
      buff[i] = 0;
  }

  /**
   * The following loop reads sensor data (encoders ticks, joint velocities and
   * force readings) and writes it in the response packet.
   */
  for(int i = 0; i < 3; i++)
    {
      float position = myStatusObjects[i]->GetPIDPosition();
      float velocity = myStatusObjects[i]->getVelocity();
      float torque   = 0;//myStatusObjects[i]->loadCell->read();

      packet[(i*3)+0] = position;
      packet[(i*3)+1] = velocity;
      packet[(i*3)+2] = torque;
    }

}
