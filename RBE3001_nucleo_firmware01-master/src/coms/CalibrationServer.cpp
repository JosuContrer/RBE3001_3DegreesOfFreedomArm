/*
 * CalibrationServer.cpp
 *
 *  Created on: Jan 20, 2019
 *      Author: tarizzo
 */

#include "CalibrationServer.h"
extern float homePosition[3];

void CalibrationServer::event(float * packet){

	/*
	   * ======= PART 1: Decode setpoints and send commands to the PID controller ==
	   */


	  for (int i = 0; i < myPumberOfCalibrationChannels; i++)
	    {
	      // get current position from arm
	    }
}

