#ifndef __CONFIG_H__
#define __CONFIG_H__


// -----------------------------------------------------------------------------
// GPS
// -----------------------------------------------------------------------------
#define PwrSwitch1_8V PB0
#define PwrSwitchGPS PA3

#define GPS_BAUDRATE    115200
#define GPS_RX_PIN      PC11
#define GPS_TX_PIN      PC10
#define GPS_RST_PIN     PB2
#define GPS_LS_PIN      PC6
#define GPS_BAUD_RATE 115200



// -----------------------------------------------------------------------------
// LoRa SPI
// -----------------------------------------------------------------------------
#define LORA_RST PB10
#define LORA_MOSI PB15
#define LORA_MISO PB14
#define LORA_SCK PB13
#define LORA_NSS PB12

#define LORA_DIO0 PB11
#define LORA_DIO1_PIN PC13
#define LORA_DIO2_PIN PB9
#define LORA_DIO3_PIN PB4
#define LORA_DIO4_PIN PB3
#define LORA_DIO5_PIN PA15

#define RADIO_ANT_SWITCH_RXTX PA1 // 1:Rx, 0:Tx
#define LORAWAN_PORT 1
// -----------------------------------------------------------------------------
// Debug
// -----------------------------------------------------------------------------
#define LORAWAN_CONFIRMED_EVERY 0



// SSD1306
#define IICSDA PB7
#define IICSCL PB6
#define OLED_RESET PA8 // Reset pin # (or -1 if sharing Arduino reset pin)

// TOUCH
#define TTP223_VDD_PIN PA2
#define TOUCH_PAD_PIN PA0

// ICM20948
#define ICM20948_ADDR 0x69

// #define PWR_1_8V_PIN PB0
// #define PWR_GPS_PIN PA3

#define BAT_VOLT_PIN PC4


//tip de transmisie
//#define PAYLOAD_USE_FULL

#define PAYLOAD_USE_CAYENNE


// -----------------------------------------------------------------------------
// Adaugat 
// -----------------------------------------------------------------------------

#define SEND_INTERVAL           10000       // Sleep for these many millis
#define GPS_WAIT_FOR_LOCK       1000        // Wait 5s after every boot for GPS lock



#endif /* __CONFIG_H__ */