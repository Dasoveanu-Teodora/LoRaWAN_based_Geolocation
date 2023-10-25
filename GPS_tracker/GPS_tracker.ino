#include "lora.h"
#include "gps.h"
#include "configuration.h"




void setup(){
	
	//    pinMode(13, OUTPUT);
    while (!Serial)
        ; // wait for Serial to be initialized
    Serial.begin(115200);
		
    delay(5000); // per sample code on RF_95 test
    Serial.println(F("Starting"));
	
	
	
}




void loop(){
	
	loop_gps();
	loop_lora();
	
	
}