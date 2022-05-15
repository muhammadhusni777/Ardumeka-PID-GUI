/*
mosquitto_pub -h 123.45.0.10 -p 1883 -t hoho -m *sudut servo*


*/
#include <Wire.h>

#include <SPI.h>
#include <Ethernet.h>
#include <PubSubClient.h>
#include "ESC.h"
#define LED_PIN (13)                    // Pin for the LED 
#define POT_PIN (A0)                    // Analog pin used to connect the potentiometer

ESC myESC (6, 1000, 2000, 1000);         // ESC_Name (PIN, Minimum Value, Maximum Value, Arm Value)


unsigned long time_now;
unsigned long time_elapsed;
unsigned long time_prev;

unsigned long time_send;
unsigned long time_send_prev;
int time_message = 500;

//MechaQMC5883 qmc;
int counter;
int azimuth =0;
int led_state = 0;
int val;
int rpm;
int speed_motor = 1000;
// Update these with values suitable for your network.
byte mac[]    = {  0xDE, 0xED, 0xBA, 0xFE, 0xFE, 0xE6 }; //0x00, 0x80, 0xE1, 0x01, 0x01, 0x01
//byte mac[]    = {  0x00, 0x80, 0xE1, 0x01, 0x01, 0x01 };

IPAddress ip(123, 45, 0, 107);
IPAddress server(123, 45, 0, 10);

void callback(char* topic, byte* message, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  
  String messageTemp;
  
  for (int i = 0; i < length; i++) {
    //Serial.print((char)message[i]);
    messageTemp += (char)message[i];
    
  }
  //val = messageTemp.toFloat();
 
  //Serial.println();
   if (String(topic) == "brightness") {
   val = messageTemp.toInt() * 255/100; 
   Serial.println(val);
   }

    if (String(topic) == "speed") {
   speed_motor = messageTemp.toInt(); 
   Serial.println(speed_motor);
    
   }
   /*
  if (String(topic) == "brightness") {
    Serial.print("Changing output to ");
    
    if(messageTemp == "on"){    
      Serial.println("on");  
      led_state = 1;
    }
     else if(messageTemp == "off"){
      Serial.println("off");
      led_state = 0;
    }
  
  }
*/
 messageTemp ="";
}

EthernetClient ethClient;
PubSubClient client(ethClient);
void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("CompassClient")) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      //client.publish("outTopic","hello world");
      // ... and resubscribe
      client.subscribe("brightness");
      client.subscribe("speed");
      client.subscribe("propeller1");
      client.subscribe("test_topic");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  } 
}
void setup() {
  pinMode (13, OUTPUT);
  Wire.begin();
  Serial.begin(115200);
  Serial.println("booting....");
  //qmc.init();
  client.setServer(server, 1883);
  client.setCallback(callback);


  
  
  
  Ethernet.begin(mac, ip);
  // Allow the hardware to sort itself out
  delay(1500);
  //qmc.setMode(Mode_Continuous,ODR_200Hz,RNG_2G,OSR_256);

   pinMode(LED_PIN, OUTPUT);             // LED Visual Output
  myESC.arm();                          // Send the Arm value
  digitalWrite(LED_PIN, HIGH);          // LED High Once Armed
  delay(5000);                           // Wait for a while
  attachInterrupt(1, encoder, RISING);
}

static char yaw_send[15];
static char rpm_send[15];



void loop() {
  time_now = millis();
  
  if (!client.connected()) {
    reconnect();
  }

  if(led_state == 1){
    digitalWrite(13, HIGH);
  } else {
    digitalWrite(13, LOW);
    }
  

  time_send = millis() - time_send_prev;
  if (time_send > time_message){
  Serial.print(counter);
  //Serial.print(" dt :");
  //Serial.print(time_elapsed);
  rpm = (counter * 120 /8);
  client.publish("Yaw",dtostrf(azimuth,6,3,yaw_send)); // kirim data
  client.publish("rpm",dtostrf(rpm,6,3,rpm_send)); // kirim data
  //client.publish("Yaw, dtostrf(100));
  Serial.println();
  time_send_prev = millis();
  counter = 0;
  }
  
  myESC.speed(speed_motor); 
  client.loop();
  time_elapsed = time_now - time_prev;
  time_prev = time_now;
 

}  

void encoder(){
  counter++;
}
