#include <SPI.h>
#include <Ethernet.h>
#include <PubSubClient.h>
#include "ESC.h"

ESC myESC (6, 1000, 2000, 1000);         
unsigned long time_now;
unsigned long time_elapsed;
unsigned long time_prev;

unsigned long time_send;
unsigned long time_send_prev;
int time_message = 500;


int counter;
int val;
int rpm;
int speed_motor = 1000;

byte mac[]    = {  0xDE, 0xED, 0xBA, 0xFE, 0xFE, 0xE6 };

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

    if (String(topic) == "speed") {
   speed_motor = messageTemp.toInt(); 
   Serial.println(speed_motor);
    
   }
   
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
      client.subscribe("speed");
      
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

  Serial.begin(115200);
  Serial.println("booting....");
  client.setServer(server, 1883);
  client.setCallback(callback);


  
  
  
  Ethernet.begin(mac, ip);

  delay(1500);



  myESC.arm();                          

  delay(5000);                          
  attachInterrupt(1, encoder, RISING);
}

static char yaw_send[15];
static char rpm_send[15];



void loop() {
  time_now = millis();
  
  if (!client.connected()) {
    reconnect();
  }

  
  time_send = millis() - time_send_prev;
  if (time_send > time_message){
  Serial.print(counter);
  
  rpm = ((counter/8)/0.5 * 60);
  
  client.publish("rpm",dtostrf(rpm,6,3,rpm_send)); // kirim data
  
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
