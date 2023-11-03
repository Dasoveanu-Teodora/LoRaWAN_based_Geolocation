#include <Wire.h> // Only needed for Arduino 1.6.5 and earlier
#include <SPI.h>
#include "loraMAC.h"
#include "config.h"
//#include "oled.h"
#include "gps.h"

//scoate ce nu ti trebuie din cod 
//trebuie sa te uiti incelalt exemplu cum creezi pachetul, trebuie sa l creezi si dupa sa il refaci

#if defined(PAYLOAD_USE_FULL)
  // includes number of satellites and accuracy
  uint8_t txBuffer[10];
#elif defined(PAYLOAD_USE_CAYENNE)
  // CAYENNE DF
  static uint8_t txBuffer[11] = {0x03, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
#endif

 bool confirmed ;

void send() {

  buildPacket(txBuffer);
  confirmed = true;
  
  Serial.println("  txbuffer send  ");
  for(int i = 0;i<5;i++)
  {  
  
    Serial.println(i);
    Serial.println(txBuffer[i]);
 
  }
 


  loraMAC_send(txBuffer, sizeof(txBuffer), LORAWAN_PORT, confirmed);
}



void setup()
{
    
   // BoardInit();
    
  Serial.begin(115200);
  delay(5000);
   
   Serial.println(" serial setup ");
   
   // Serial.println(" gps setup ");
    setup_gps();

    delay(500);
  //  Serial.println("LoRaWan Demo");

    loraMAC_setup();

}



void loop()
{

   loop_gps();
   loraMAC_loop();
    
  
  // Send every SEND_INTERVAL millis
  static uint32_t last = 0;
  static bool first = true;
  confirmed = false;

  if (0 == last || millis() - last > SEND_INTERVAL) {
    //pt logger 
   // send();
    if (0 < gps_hdop() && gps_hdop() < 50 && gps_latitude() != 0 && gps_longitude() != 0) {
      last = millis();
      first = false;
      Serial.println("TRANSMITTING");
      send();
    } else {
      if (first) {
        Serial.println("Waiting GPS lock\n");
        first = false;
      }
      if (millis() < GPS_WAIT_FOR_LOCK) {
         Serial.println("sleep");
      }
    }
  }


}
