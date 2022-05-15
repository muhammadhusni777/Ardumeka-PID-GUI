
#include "ESC.h"
#define LED_PIN (13)                    
#define POT_PIN (A0)                    
ESC myESC (6, 1000, 2000, 1000);         

int val;                                
int counter;

unsigned long sensor_time;
unsigned long sensor_time_prev;

int sensor;
int sensor_sampling_time = 500;
void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);             
  myESC.arm();                          
  digitalWrite(LED_PIN, HIGH);          
  attachInterrupt(1, encoder, RISING);
  delay(5000);                          
}

void loop() {
  val = analogRead(POT_PIN);            
  val = map(val, 0, 735, 1000, 2000);  
  myESC.speed(val);                    
  //delay(15);         

  sensor_time = millis() - sensor_time_prev;
  if (sensor_time > sensor_sampling_time){
    sensor = ((counter/8)/0.5 * 60);
    counter = 0;
    Serial.println(sensor);
    sensor_time_prev = millis();
    
}
}

void encoder(){
  counter++;
}
