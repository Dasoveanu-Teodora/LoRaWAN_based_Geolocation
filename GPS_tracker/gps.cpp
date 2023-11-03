
#include <Arduino.h>
#include <HardwareSerial.h>
#include <TinyGPS++.h>
//#include <TinyGPSPlus.h>
//#include "config.h"
#include "gps.h"


HardwareSerial Serial4(GPS_RX_PIN, GPS_TX_PIN);
#define _serial_gps Serial4

TinyGPSPlus gps;

uint32_t LatitudeBinary;
uint32_t LongitudeBinary;
uint16_t altitudeGps;
uint8_t hdopGps;
uint8_t sats;
char t[32]; // used to sprintf for Serial output



void gps_time(char * buffer, uint8_t size) {
    snprintf(buffer, size, "%02d:%02d:%02d", gps.time.hour(), gps.time.minute(), gps.time.second());
}

float gps_latitude() {
    return gps.location.lat();
}

float gps_longitude() {
    return gps.location.lng();
}

float gps_altitude() {
    return gps.altitude.meters();
}

float gps_hdop() {
    return gps.hdop.hdop();
}

uint8_t gps_sats() {
    return gps.satellites.value();
}




void setup_gps(void)
{
 
  _serial_gps.begin(GPS_BAUDRATE, SERIAL_8N1);

   Serial.begin(115200);
  delay(5000);

    /* drive GNSS RST pin low */
  pinMode(GPS_RST_PIN, OUTPUT);
  digitalWrite(GPS_RST_PIN, LOW);

  /* activate 1.8V<->3.3V level shifters */
  pinMode(GPS_LS_PIN,  OUTPUT);
  digitalWrite(GPS_LS_PIN,  HIGH);

  /* keep RST low to ensure proper IC reset */
  delay(200);

  /* release */
  digitalWrite(GPS_RST_PIN, HIGH);

  /* give Sony GNSS few ms to warm up */
  delay(100);

  /* Leave pin floating */
  pinMode(GPS_RST_PIN, INPUT);

  // _serial_gps.write("@VER\r\n");

  /* Idle */
  // _serial_gps.write("@GSTP\r\n");      delay(250);

  /* GGA + GSA + RMC */
  _serial_gps.write("@BSSL 0x25\r\n"); delay(250);
  /* GPS + GLONASS */
  _serial_gps.write("@GNS 0x3\r\n");   delay(250);

  // _serial_gps.write("@GSW\r\n"); /* warm start */
  // _serial_gps.write("@GSR\r\n"); /* hot  start */
  _serial_gps.write("@GCD\r\n"); /* cold start */

  delay(250);
  

  Serial.println(F("DeviceExample.ino"));
  Serial.println(F("A simple demonstration of TinyGPSPlus with an attached GPS module"));
  Serial.print(F("Testing TinyGPSPlus library v. ")); Serial.println(TinyGPSPlus::libraryVersion());
  Serial.println(F("by Mikal Hart"));
  Serial.println();

}


void displayInfo()
{
  Serial.print(F("Location: ")); 
  if (gps.location.isValid())
  {
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.print(gps.location.lng(), 6);
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F("  Date/Time: "));
  if (gps.date.isValid())
  {
    Serial.print(gps.date.month());
    Serial.print(F("/"));
    Serial.print(gps.date.day());
    Serial.print(F("/"));
    Serial.print(gps.date.year());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F(" "));
  if (gps.time.isValid())
  {
    if (gps.time.hour() < 10) Serial.print(F("0"));
    Serial.print(gps.time.hour());
    Serial.print(F(":"));
    if (gps.time.minute() < 10) Serial.print(F("0"));
    Serial.print(gps.time.minute());
    Serial.print(F(":"));
    if (gps.time.second() < 10) Serial.print(F("0"));
    Serial.print(gps.time.second());
    Serial.print(F("."));
    if (gps.time.centisecond() < 10) Serial.print(F("0"));
    Serial.print(gps.time.centisecond());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.println();
}




void loop_gps(void)
{
 

    // This sketch displays information every time a new sentence is correctly encoded.

  while (_serial_gps.available() > 0)
    if (gps.encode(_serial_gps.read()))
      displayInfo();

  if (millis() > 5000 && gps.charsProcessed() < 10)
  {
    Serial.println(F("No GPS detected: check wiring."));
    while(true);
  }


}


#if defined(PAYLOAD_USE_FULL)

    // More data than PAYLOAD_USE_CAYENNE
    void buildPacket(uint8_t txBuffer[10])
    {
        LatitudeBinary = ((gps.location.lat() + 90) / 180.0) * 16777215;
        LongitudeBinary = ((gps.location.lng() + 180) / 360.0) * 16777215;
        altitudeGps = gps.altitude.meters();
        hdopGps = gps.hdop.value() / 10;
        sats = gps.satellites.value();

        sprintf(t, "Lat: %f", gps.location.lat());
        Serial.println(t);
        sprintf(t, "Lng: %f", gps.location.lng());
        Serial.println(t);
        sprintf(t, "Alt: %d", altitudeGps);
        Serial.println(t);
        sprintf(t, "Hdop: %d", hdopGps);
        Serial.println(t);
        sprintf(t, "Sats: %d", sats);
        Serial.println(t);

        txBuffer[0] = ( LatitudeBinary >> 16 ) & 0xFF;
        txBuffer[1] = ( LatitudeBinary >> 8 ) & 0xFF;
        txBuffer[2] = LatitudeBinary & 0xFF;
        txBuffer[3] = ( LongitudeBinary >> 16 ) & 0xFF;
        txBuffer[4] = ( LongitudeBinary >> 8 ) & 0xFF;
        txBuffer[5] = LongitudeBinary & 0xFF;
        txBuffer[6] = ( altitudeGps >> 8 ) & 0xFF;
        txBuffer[7] = altitudeGps & 0xFF;
        txBuffer[8] = hdopGps & 0xFF;
        txBuffer[9] = sats & 0xFF;
    }

#elif defined(PAYLOAD_USE_CAYENNE)

    // CAYENNE DF
    void buildPacket(uint8_t txBuffer[11])
    {
        sprintf(t, "Lat: %f", gps.location.lat());
        Serial.println(t);
        sprintf(t, "Lng: %f", gps.location.lng());
        Serial.println(t);        
        sprintf(t, "Alt: %f", gps.altitude.meters());
        Serial.println(t);        
        int32_t lat = gps.location.lat() * 10000;
        int32_t lon = gps.location.lng() * 10000;
        int32_t alt = gps.altitude.meters() * 100;
        
        txBuffer[2] = lat >> 16;
        txBuffer[3] = lat >> 8;
        txBuffer[4] = lat;
        txBuffer[5] = lon >> 16;
        txBuffer[6] = lon >> 8;
        txBuffer[7] = lon;
        txBuffer[8] = alt >> 16;
        txBuffer[9] = alt >> 8;
        txBuffer[10] = alt;
    }

#endif



