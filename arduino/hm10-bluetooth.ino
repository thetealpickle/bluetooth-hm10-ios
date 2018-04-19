#include <SoftwareSerial.h>
#define LED_PIN 2

SoftwareSerial mySerial(7,8); // RX, TX

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  mySerial.begin(9600);
}

void loop() {
  int c;

  if (mySerial.available()) {
    c = mySerial.read();
    Serial.println("Got input: ");

     if (c != 0) {
      Serial.println("on");
      digitalWrite(LED_PIN, HIGH); 
     } else {
      Serial.println("off");
      digitalWrite(LED_PIN, LOW); 
     }
  }
}
