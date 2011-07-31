/*
  AnalogReadSerial
 Reads an analog input on requested pin, prints the result to the serial monitor 
 
 (C) Paolo Bosetti 2011
 */
#define BAUDRATE 9600

void setup() {
  Serial.begin(BAUDRATE);
}

void loop() {
  char ch;
  if(Serial.available()) {
    ch = Serial.read();
    switch(ch) {
    case '0'...'5':
      unsigned int pin;
      pin = ch - '0';
      Serial.println(analogRead(pin), DEC);
      break;
    default:
      Serial.println("-");
    }
  }
  delay(100);
}





