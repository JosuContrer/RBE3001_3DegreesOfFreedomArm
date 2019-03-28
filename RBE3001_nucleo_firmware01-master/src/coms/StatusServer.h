/*
 * StatusServer.h
 *
 *  Created on: Jan 18, 2019
 *      Author: tarizzo
 */

#ifndef SRC_COMS_STATUSSERVER_H_
#define SRC_COMS_STATUSSERVER_H_

#include <PID_Bowler.h>
#include <PacketEvent.h>
#include "../drivers/MyPid.h"
#include <cmath>              // needed for std::abs

#define STATUS_SERVER_ID 03      // identifier for this server

/**
 *  @brief Class that receives setpoints through HID and sends them to
 *         the Status controller. Extends the `PacketEventAbstract' class.
 */
class StatusServer: public PacketEventAbstract
{
 private:
	PIDimp ** myStatusObjects;    // array of StatusServers - one for each joint
	int myPumberOfStatusChannels;

 public:
  StatusServer(PIDimp ** StatusObjects, int numberOfStatusChannels)
    : PacketEventAbstract(STATUS_SERVER_ID)
  {
    myStatusObjects = StatusObjects;
    myPumberOfStatusChannels = numberOfStatusChannels;
  }

  // This method is called every time a packet from MATLAB is received
  // via HID
  void event(float * buffer);
};


#endif /* SRC_COMS_STATUSSERVER_H_ */
