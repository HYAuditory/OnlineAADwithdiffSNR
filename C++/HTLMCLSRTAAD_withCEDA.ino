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


//SoftwareSerial softwareSerial(2,3); 
wavTrigger wTrig;             // WAV Trigger object
Metro gLedMetro(500);         // LED blink interval timer
Metro gSeqMetro(6000);        // Sequencer state machine interval timer

String alphabet = "abcdefghijklmnopqrstuvwxyz";

void setup() {

  // Serial monitor
  //softwareSerial.begin(9600);
  Serial.begin(9600);   // When use COM Port
  
  pinMode(13, OUTPUT);  // WAV Trigger onset
  pinMode(12, OUTPUT);  // Real sound onset
  pinMode(11, OUTPUT);  // 
  pinMode(10, OUTPUT);
  pinMode(A0, INPUT);  // 
  pinMode(A1, INPUT);
  
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
int track2 = 1;
char inp;
int input;
int idx;
int idx2;
int prac = 31; // track 20 - -30
int thres = 1;    // 11 Input Analog Sound threshold - should you check this

void loop() {
  digitalWrite(13, LOW);
  digitalWrite(12, LOW);
  digitalWrite(10, LOW);

  //int sound_L = analogRead(A0);
  //int sound_R = analogRead(A1);
  
  //input = softwareSerial.read();
  input = Serial.read();
  
    //////// HTL ////////
  if (input == 'H'){
    track = 2;
    while (true) {
      //input = softwareSerial.read();
      input = Serial.read();
      
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
      //inp = softwareSerial.read();
      inp = Serial.read();
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
    int track2 = 1;
    while(true){
      // receive command
      //inp = softwareSerial.read();
      inp = Serial.read();
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
    prac = 207;
    while(true){
      //inp = softwareSerial.read();
      inp = Serial.read();
      if (inp == 'N'){
        wTrig.trackPlaySolo(prac); 
        prac=228;}
      else if (inp == 'E'){ break;}
    }
  }
  ///////// AAD- practice /////////
  else if (input == 'R'){
    prac = 45;
    while(true){
      //inp = softwareSerial.read();
      inp = Serial.read();
      if (inp == 'N'){
        wTrig.trackPlaySolo(prac); 
        prac++;}
      else if (inp == 'E'){ break;}
    }
  }
  //////// Online AAD ////////
  else if (input == 'A'){   // AAD mode
    track = 1;
    while(true){
      digitalWrite(13, LOW);
      
      //inp = softwareSerial.read();
      inp = Serial.read();
      if (inp == 49){   // start AAD task
 
        // Start sound
        //wTrig.trackGain(0, 70);
        wTrig.trackPlaySolo(track);
        
        digitalWrite(13, HIGH);      // Toward Cyton board /Trigger for Checking WAV Trigger, not sound onset
  
        while(true) {    
        // Detect analog signal of sound(beep sound)
        int sound_L = analogRead(A0);
        int sound_R = analogRead(A1);
  
        if ( sound_L > thres || sound_R > thres) {    
          digitalWrite(12, HIGH);  // Toward Cyton board /Trigger for onset sound
          digitalWrite(10, HIGH);   // Check LED (ouside)
          delay(62500);            // Play Wav file during 63s 
          digitalWrite(12, LOW);
          digitalWrite(10, LOW);
          track++;                 // for next track
          break;          
          }          
        }    
      }
      else if (inp == 51){    // practice
    
        wTrig.trackPlaySolo(prac);  // the track for practice
        digitalWrite(10,HIGH);
        delay(15000);     
        prac++;
      }
      else if (inp == '0') { break;}  // end  
    }
  }
}        







              
