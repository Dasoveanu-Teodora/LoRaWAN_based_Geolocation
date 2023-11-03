#pragma once
#include <TinyGPS++.h>
#include "config.h"


extern TinyGPSPlus gps;

float gps_latitude(void);
void gps_time(char * buffer, uint8_t size);
float gps_longitude(void);
float gps_hdop(void);
uint8_t gps_sats(void);
void setup_gps(void);
void loop_gps(void);

// #if defined(PAYLOAD_USE_FULL)
//  {// More data than PAYLOAD_USE_CAYENNE
//     void buildPacket(uint8_t txBuffer[10]);  
//  }
// #elif defined(PAYLOAD_USE_CAYENNE)
void buildPacket(uint8_t *txBuffer);