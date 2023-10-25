
#include "gps.h"


HardwareSerial gpsPort(GPS_RX, GPS_TX);

void GPS_WaitAck(String cmd, String arg = "")
{
  if (arg != "")
  {
    gpsPort.print(cmd);
    gpsPort.print(" ");
    gpsPort.println(arg);
  }
  else
  {
    gpsPort.println(cmd);
  }
  String ack = "";
  uint32_t smap = millis() + 500;
  while (millis() < smap)
  {
    if (gpsPort.available() > 0)
    {
      ack = gpsPort.readStringUntil('\n');
      String acc = "[" + cmd.substring(1) + "] " + "Done";
      if (ack.startsWith(acc))
      {
        Serial.printf("%s %s send success \n", cmd.c_str(), arg.c_str());
        return;
      }
    }
  }
  Serial.printf("%s %s send time out \n", cmd.c_str(), arg.c_str());

}

void setup_gps()
{
  pinMode(PwrSwitch1_8V, OUTPUT);
  digitalWrite(PwrSwitch1_8V, HIGH);

  pinMode(PwrSwitchGPS, OUTPUT);
  digitalWrite(PwrSwitchGPS, HIGH);



  Serial.println("GPS Each test");
  Serial.println("Never try to send @FER, it clears GPS firmware!!");
  Serial.println("Never try to send @FER, it clears GPS firmware!!");
  Serial.println("Never try to send @FER, it clears GPS firmware!!");
  gpsPort.begin(GPS_BAUD_RATE);
  pinMode(GPS_EN, OUTPUT);
  digitalWrite(GPS_EN, HIGH);
  pinMode(GPS_RST, GPIO_PULLUP);
  // Set  Reset Pin as 0
  digitalWrite(GPS_RST, LOW);
  // Scope shows 1.12s (Low Period)
  delay(200);
  // Set  Reset Pin as 1
  digitalWrite(GPS_RST, HIGH);
  delay(500);

  GPS_WaitAck("@GSTP");
  GPS_WaitAck("@BSSL", "0x2EF");
  GPS_WaitAck("@GSOP", "1 1000 0");
  GPS_WaitAck("@GNS", "0x03");
  //! Start GPS connamd
  GPS_WaitAck("@GSR");
}

void loop_gps(void)
{
  static uint32_t Millis;
  if (millis() - Millis > 500)
  {
    Serial.printf("millis[%lu]\n", millis());
    Millis = millis();
  }

  while (gpsPort.available() )
    Serial.write(gpsPort.read());


  while (Serial.available())
    gpsPort.write(Serial.read());

}
