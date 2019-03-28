/*
 * CalibrationServer.h
 *
 *  Created on: Jan 20, 2019
 *      Author: tarizzo
 */

#ifndef SRC_COMS_CALIBRATIONSERVER_H_
#define SRC_COMS_CALIBRATIONSERVER_H_

#include <PID_Bowler.h>
#include <PidServer.h>
#include <PacketEvent.h>
#include "../drivers/MyPid.h"
#include <cmath>              // needed for std::abs

#define CALIBRATION_SERVER_ID 04

extern float homePosition[3];

class CalibrationServer: public PacketEventAbstract
{
 private:
	PIDimp ** myCalibrationObjects;    // array of StatusServers - one for each joint
	int myPumberOfCalibrationChannels;

 public:
  CalibrationServer(PIDimp ** CalibrationObjects, int numberOfStatusChannels)
    : PacketEventAbstract(CALIBRATION_SERVER_ID)
  {
    myCalibrationObjects = CalibrationObjects;
    myPumberOfCalibrationChannels = numberOfStatusChannels;
  }

  // This method is called every time a packet from MATLAB is received
  // via HID
  void event(float * buffer);
};

#endif /* SRC_COMS_CALIBRATIONSERVER_H_ */
