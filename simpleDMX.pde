EnttecOutput enttecOutput;

import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

Slider[] sliders = new Slider[24];

void setup() 
{
  size(1200, 800);
  println(Serial.list());
  for(int i = 0; i < sliders.length; i++) {
    sliders[i] = new Slider();
    
  }
}

boolean keyReleased = true;
int selected = 0;
boolean setupDone = false;
void draw() {
  background(0);
  if(setupDone) {
    for(int i = 0; i < sliders.length; i++) {
      int ch = i + 1;
      sliders[i].draw(new PVector(i*40+20, 10), ch);
      if(enttecOutput != null) { enttecOutput.setChannel(ch, sliders[i].value); }
    } 
  }
  else {
    setupWindow();
  }
  if(enttecOutput != null) { enttecOutput.draw(); }

}



void setupWindow() {
    
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
  
  void setChannel(int ch, int val) {
    if(ch >= 0 && ch < DMXforOutput.length && val >= 0 && val <= 255) {
      DMXforOutput[ch] = val;
    }
  }
  
  void sendChannel(int ch, int val) {
    dmxOutput.set(ch, val);
    println("Sent dmx ch: " + str(ch) + " val: " + str(val));
  }
  

}