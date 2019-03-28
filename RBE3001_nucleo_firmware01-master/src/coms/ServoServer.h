/**
 * @file PidServer.h
 * @brief PidServer for the RBE3001 robotic arm
 *
 * @section RBE3001 - Nucleo Firmware - PidServer
 *
 * Instructions
 * ------------
 * This class implements a communication server that can be
 * used to send given setpoints (in joint space) to the robotic arm.
 * Setpoints generated in MATLAB and sent over HDI will be made available
 * to the `event()' function below. See the code in `PidServer.cpp' for
 * for more details.
 *
 * IMPORTANT - Multiple communication servers can run in parallel, as shown
 *             in the main file of this firmware
 *             (see 'Part 2b' in /src/Main.cpp). To ensure that communication
 *             packets generated in MATLAB are routed to the appropriate
 *             server, we use unique identifiers. The identifier for this
 *             server is the integer number 37.
 *             In general, the identifier can be any 4-byte unsigned
 *             integer number.
 */

#ifndef RBE3001_SERVO_SERVER
#define RBE3001_SERVO_SERVER

#include <PID_Bowler.h>
#include <PacketEvent.h>
#include "../drivers/MyPid.h"
#include <cmath>              // needed for std::abs

#define SERVO_SERVER_ID 05      // identifier for this server

/**
 *  @brief Class that receives setpoints through HID and sends them to
 *         the PID controller. Extends the `PacketEventAbstract' class.
 */
class ServoServer: public PacketEventAbstract
{
 private:

 public:
  ServoServer ()
    : PacketEventAbstract(SERVO_SERVER_ID)
  {

  }
  void event(float * buffer);
};

#endif /* end of include guard: RBE3001_PID_SERVER */
