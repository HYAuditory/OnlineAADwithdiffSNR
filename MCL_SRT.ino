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
//int inone = 0;
//int intwo = 0;
//int inthree = 0;
int Wtrack = 0;
void loop() {
          digitalWrite(7,LOW);
        digitalWrite(6,LOW);
        digitalWrite(5,LOW);
  int input = softwareSerial.read();
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
    wTrig.trackPlaySolo(2);  // SNR 0dB
    delay(4000);
    
      while (true){  // 세자리수 받기
        digitalWrite(4,HIGH);
        digitalWrite(7,LOW);
        digitalWrite(6,LOW);
        digitalWrite(5,LOW);

        int inone = softwareSerial.read();

          while(0 <= inone  < 10){ 
            int intwo = softwareSerial.read();    // 없는 경우 'X'
            delay(500);
            digitalWrite(7,HIGH);        
 
             while (0 <= intwo < 0){
              if (intwo == 'X'){
                track = char(inone);
                break;}
             
              int inthree = softwareSerial.read();    // 없는 경우 'X'
              delay(500);
              digitalWrite(6,HIGH);
              
              if (0 <= inthree < 10){  // 세자리수 다 받음
                digitalWrite(5,HIGH);
                
                  // track number 조합
                  if (intwo == 'X'&& inthree == 'X'){ // 한자리수
                    track = char(inone);}
                  else if (inthree == 'X'){   // 두자리수
                    track = char(inone)+ char(intwo);}
                  else{ // 세자리수
                    track = char(inone)+char(intwo)+char(inthree);}   
                     
               wTrig.trackPlaySolo(int(track));
               delay(4500);          
               break;}}}  // 다시 세자리수 받으러
     }  
   }
} 


              
