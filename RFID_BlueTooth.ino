#include <SoftwareSerial.h>

#include <require_cpp11.h>
#include <MFRC522.h>
#include <deprecated.h>
#include <MFRC522Extended.h>
#include <SPI.h>

#define SS_PIN 10
#define RST_PIN 9
#define LED_G 5 //define green LED pin
#define LED_R 4 //define red LED
#define BUZZER 6 //buzzer pin
#define ACCESS_DELAY 2000
#define DENIED_DELAY 1000

MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.
SoftwareSerial btSerial(2,3);

String bt_rx;
String LastID;
String ID;

void setup() {
  pinMode(LED_G, OUTPUT);
  pinMode(LED_R, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  noTone(BUZZER);
  
  Serial.begin(9600);
  btSerial.begin(9600);
  SPI.begin();          // Initiate  SPI bus
  mfrc522.PCD_Init();   // Initiate MFRC522

}

void loop() {
  if (btSerial.available()) {
    bt_rx = btSerial.readString();
    Serial.print("Received:");
    Serial.println(bt_rx);
    if(bt_rx == "Bee"){
      tone(BUZZER, 300);
      delay(1000);
      noTone(BUZZER);
    }else if(bt_rx == "Yes"){
      digitalWrite(LED_G, HIGH);
      delay(ACCESS_DELAY);
      digitalWrite(LED_G, LOW);
    }else if(bt_rx == "No"){
      digitalWrite(LED_R, HIGH);
      tone(BUZZER, 300);
      delay(DENIED_DELAY);
      digitalWrite(LED_R, LOW);
      noTone(BUZZER);
    }
  }
  if ( ! mfrc522.PICC_IsNewCardPresent()) 
  {
    return;
  }
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial()) 
  {
    return;
  }
  String content= "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++) 
  {
     content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
     content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  content.toUpperCase();
  ID = content;
  if(LastID != ID){
    LastID = ID;
    Serial.print("UID tag :");
    Serial.println(ID);
    btSerial.println(ID);
  }
}
