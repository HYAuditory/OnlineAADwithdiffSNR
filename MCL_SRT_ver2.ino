///////////////////////////////////////
/////                             /////
/////         Arduino UNO         /////
/////       For SRT/MCL/SNR       /////
/////                             /////
/////////////////////////////////////// 

#include <Metro.h>
#include <AltSoftSerial.h>    // Arduino build environment requires this
#include <wavTrigger.h>
#include <SoftwareSerial.h>


SoftwareSerial softwareSerial(2,3); 
wavTrigger wTrig;             // WAV Trigger object
Metro gLedMetro(500);         // LED blink interval timer
Metro gSeqMetro(6000);        // Sequencer state machine interval timer

void setup() {

  // Serial monitor
  softwareSerial.begin(9600);
  //Serial.begin(9600);   // When use COM Port
  
  pinMode(7, OUTPUT);  // WAV Trigger onset
  pinMode(6, OUTPUT);  // Real sound onset
  pinMode(5, OUTPUT);  // 
  pinMode(4, OUTPUT);
  
  // If the Arduino is powering the WAV Trigger, we should wait for the WAV
  //  Trigger to finish reset before trying to send commands.
  delay(1000);
  wTrig.start();  
  delay(10);

  // Send a stop-all command and reset the sample-rate offset, in case we have
  //  reset while the WAV Trigger was already playing.
  wTrig.stopAllTracks();   
  wTrig.samplerateOffset(0);  
}

int track = 1;
char inp;

void loop() {
  String s;
  int input = softwareSerial.read();
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  
  // HTL
  if (input == 'H'){
    
    while (true) {
      input = softwareSerial.read();
      if (input == '1'){
        wTrig.trackPlaySolo(track);
        track++;
      }
      else if (input == 'X'){
        input == 'H';
        break;
      }
    }
  }
  // MCL 
  else if (input == 'M'){
    
    while (true){
      input = softwareSerial.read();
      
      if (input != 'M'){  // first MCL
        track = int(input) + 5;
        wTrig.trackPlaySolo(track);
        input = 0;
   
        while (true) {
          input = softwareSerial.read(); //
          
          if (input == '1'){    // 
            track = track - 1;
            wTrig.trackPlaySolo(track);
          }
          else if (input == '2'){    // 
            track = track + 1;
            wTrig.trackPlaySolo(track);
          }
          else if (input == '3'){    // 
            track = track - 2;
            wTrig.trackPlaySolo(track);
          }
          else if (input == '4'){    // 
            track = track + 2;
            wTrig.trackPlaySolo(track);
          }
          else if (input == '5'){
            input = 0;
            break;
          }}
       break;
      }} 
  }
  // SRT
  else if (input == 'S'){
    //wTrig.trackPlaySolo(2);  // SNR 0dB
    //delay(4000);
        
        while(softwareSerial.available()){
          //String s = softwareSerial.readStringUntil('R');
          char inp = softwareSerial.read();
          s.concat(inp);
          digitalWrite(5,HIGH);}

        int indx = s.indexOf('R');

        int index = s.length();
        int track = s.substring(indx+1,index).toInt();
        if (track = 16){
            digitalWrite(7,HIGH);
            delay(500);
            digitalWrite(7,LOW);
         }
        wTrig.trackPlaySolo(track);
        delay(5000);
        digitalWrite(5,LOW);
        s = "" ;
  }            
} 


              
