#pragma once


#include "config.h"
#include <vector>
#include <lmic.h>
#include <hal/hal.h>
#include <SPI.h>

void loraMAC_setup(void);
void loraMAC_loop(void);
void loraMAC_send(uint8_t * data, uint8_t data_size, uint8_t port, bool confirmed);


