/**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port. 
 * This example works with the Wiring / Arduino program that follows below.
 */

EnttecOutput enttecOutput;

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

void setup() 
{
  size(800, 800);
 
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
 // String portName = Serial.list()[0];
 // myPort = new Serial(this, portName, 9600);
  
  
  println(Serial.list());
}

boolean keyReleased = true;
int selected = 0;
boolean setupDone = false;
void draw() {
  
  
  if(setupDone) {
  }
  else {
    setupWindow();
  }
  

}

void setupWindow() {
    background(0);
  for(int i = 0; i < Serial.list().length; i++) {
    if(i == selected) fill(255, 0, 0); else fill(255);
    text(Serial.list()[i], 15, i*15+20);
  }
  if(keyPressed && keyReleased) {
    if(keyCode == DOWN) {
      selected = getNext(selected, 0, Serial.list().length-1);
    }
    else if(keyCode == UP) {
      selected = getReverse(selected, 0, Serial.list().length-1);
    }
    else if(key == ENTER) {
      enttecOutput = new EnttecOutput(this, Serial.list()[selected]);
      setupDone = true;
    }
    keyReleased = false;
  }
  else if(!keyPressed) {
    keyReleased = true;
  }
}

int getNext(int val, int lo, int hi) {
  if(val >= lo && val <= hi) val++;
  if(val > hi || val < lo) val = lo;
  return val;
}

int getReverse(int val, int lo, int hi) {
  if(val >= lo && val <= hi) val--;
  if(val < lo || val > hi) val = hi;
  return val;
}




int[] DMXforOutput = new int[512];

import dmxP512.*;
import processing.serial.*;

DmxP512 dmxOutput;

class EnttecOutput {
  String port;
  int[] lastDMX;
  int delayBetweenPackets = 1;
  long lastPacketMillis;
  
  int DMXPRO_BAUDRATE=115000;
  int universeSize=512;
  
  boolean inUse;
  
  EnttecOutput() {
  }
  
  EnttecOutput(PApplet parent, String port) {
    try {
     this.port = port;
     lastDMX = new int[DMXforOutput.length];
     dmxOutput = new DmxP512(parent, universeSize, false);
     dmxOutput.setupDmxPro(port, DMXPRO_BAUDRATE);
     inUse = true;
    }
    catch (Exception e) {
     e.printStackTrace();
     inUse = false;
    }
  }
  
  
  void draw() {
    if(inUse) {
      sendUniversum();
    }
  }
  
  void sendUniversum() {
    if(lastDMX.length != DMXforOutput.length) {
      lastDMX = new int[DMXforOutput.length];
    }
    for(int i = 0; i < DMXforOutput.length; i++) {
      int newVal = DMXforOutput[i];
      if(newVal != lastDMX[i]) {
        sendChannel(i, newVal);
        lastDMX[i] = newVal;
      }
    }
  }
  
  void sendChannel(int ch, int val) {
    dmxOutput.set(ch, val);
    println("Sent dmx ch: " + str(ch) + " val: " + str(val));
  }
  

}