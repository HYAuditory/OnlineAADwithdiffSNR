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

String alphabet = "abcdefghijklmnopqrstuvwxyz";

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

int track = 2;
int track2 = 1;
char inp;
int input;
int idx;
int idx2;
int prac = 284;
void loop() {
  
  input = softwareSerial.read();
  
  //////// HTL ////////
  if (input == 'H'){
    
    while (true) {
      input = softwareSerial.read();
      
      if (input == '1'){
        wTrig.trackPlaySolo(track);
        track++;
      }
      else if (input == '0'){
        wTrig.trackPlaySolo(1);
      }
      else if (input == 'X'){
        break;
      }
      
    }
    
  }
  //////// MCL ////////
  else if (input == 'M'){
    
    while(true){
      inp = softwareSerial.read();
      idx = alphabet.indexOf(inp);
      
      if (idx != -1){
        //track = track + idx;
        wTrig.trackPlaySolo(idx);}
        
      else if (idx == -1 && inp == '0'){
        break;}
    }
  
  }
  //////// SRT ////////
  else if (input == 'S'){
    int prac = 284;
    int track2 = 1;
    while(true){
      // receive command
      inp = softwareSerial.read();
      // to int
      idx2 = alphabet.indexOf(inp);
      if (idx2 != -1){
        // play
        track2 = track2 + idx2;
        wTrig.trackPlaySolo(track2);    
      }  
      else if (idx2 == -1 && inp == '0'){
        break;}
    }      
  }
  ///////// SRT- practice /////////
  else if (input == 'P'){
    wTrig.trackPlaySolo(prac); 
    prac = 304;  
  }
}        



              
