String readString;


#include <Wire.h> 

#include "ESC.h"
ESC myESC (6, 1000, 2000, 1000);         // ESC_Name (PIN, Minimum Value, Maximum Value, Arm Value)


int bldc_speed = 1000;
int counter;
int rpm;

unsigned long message_time;
unsigned long message_time_prev;

void setup() {
   myESC.arm();
   delay(5000);
  attachInterrupt(1, encoder, RISING);      
  Serial.begin(9600);
 
}





void loop() {
  while (Serial.available()) {
    char c = Serial.read();  
    readString += c; 
    delay(2);  
  }

    if (readString.length() >0) { 
    bldc_speed  = readString.toInt();  
    
 readString=""; 
}

myESC.speed(bldc_speed); 

message_time = millis() - message_time_prev;
if (message_time > 500){
  rpm = (counter/8)/0.5 * 60;
  Serial.println(rpm);
  message_time_prev = millis();
  counter = 0;
}

}


void encoder(){
  counter++;
}
