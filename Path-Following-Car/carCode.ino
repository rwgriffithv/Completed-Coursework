//McaRT: Robert Griffith 304833256, Taasin Saquib 304757196, Michael Zhou 804663317
#include <stdio.h>
 
int sensorValue_LEFT;  //A0
int sensorValue_RIGHT;  //A1
int sensorValue_MID;    //A2
 
int e_LEFT;
int e_RIGHT;
int errorP;   //position error
int prev_errorP = 0;  //previous position error
int errorD;   //change in error
int onTrack;  //middle sensor reading, if we're on track

// H denotes an H-bridge pin
int out_LEFTp; // D5 -> H2  controls direction of motor spin
int out_LEFTn; // D6 -> H7
 
int out_RIGHTp;  // D10 -> H15
int out_RIGHTn;  // D11 -> H10
 
int out_speedLEFT = 0; // D9 -> H1
int out_speedRIGHT = 0; // D3 -> H9

int sensorValue_MAG;
int LED = 13;

 
void setup() {
pinMode(A0, INPUT);
pinMode(A1, INPUT);
pinMode(A2, INPUT);
pinMode(A3, INPUT);
// initialize serial communications at 9600 bps:
Serial.begin(9600);
}
 
void loop() {
sensorValue_LEFT = analogRead(A0);
sensorValue_RIGHT = analogRead(A1);
sensorValue_MID = analogRead(A2);
sensorValue_MAG = analogRead(A3);
if (sensorValue_MAG > 500)
  digitalWrite(LED, HIGH);
else
  digitalWrite(LED, LOW);

//Positional errror based on sensors
if (sensorValue_LEFT >= 960)    e_RIGHT = 0;
else if (sensorValue_LEFT >= 900)   e_RIGHT = 1;
else if (sensorValue_LEFT >= 600)   e_RIGHT = 2;
else if (sensorValue_LEFT >= 300)   e_RIGHT = 3;
else  e_RIGHT = 4;
 
if (sensorValue_RIGHT >= 975)   e_LEFT = 0;
else if (sensorValue_RIGHT >= 900)    e_LEFT = 1;
else if (sensorValue_RIGHT >= 600)   e_LEFT = 2;
else if (sensorValue_RIGHT >= 300)    e_LEFT = 3;
else  e_LEFT = 4;

onTrack = sensorValue_MID < 700;

//If if loses the track, it will keep treating the error as the last error it held 
//which should be the max error of 4
if(!onTrack && !e_LEFT && !e_RIGHT)
  errorP = prev_errorP;
else
  errorP = e_RIGHT - e_LEFT;

errorD = errorP - prev_errorP;
prev_errorP = errorP;

 
//error between -2 and 2 indicates it’s on the line so we want wheels to still go forward
//otherwise, one of the wheels will start to turn backwards to make a sharper turn
out_LEFTp = (errorP < 3);
out_RIGHTp = (errorP > -3);
 
out_LEFTn = !out_LEFTp;
out_RIGHTn = !out_RIGHTp;
 
//PD won’t affect the inner wheel when it spins backwards
//the speed of a sharp turn is controlled by PD through outer wheel
//the constants used were found experimentally
out_speedLEFT = 155 - 80*out_LEFTn - 25*out_LEFTp*(errorP + errorD);
out_speedRIGHT = 155 - 80*out_RIGHTn + 25*out_RIGHTp*(errorP + errorD);

digitalWrite(5, out_LEFTp); 
digitalWrite(6, out_LEFTn);
digitalWrite(10, out_RIGHTp);
digitalWrite(11, out_RIGHTn);

analogWrite(9, out_speedLEFT);
analogWrite(3, out_speedRIGHT);

delay(1);
}
