int[] DMXforOutput = new int[513];

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
  
  boolean[] chInUse = new boolean[513];
  
  EnttecOutput() {
  }
  
  EnttecOutput(PApplet parent, String port) {
    try {
     this.port = port;
     lastDMX = new int[DMXforOutput.length];
     dmxOutput = new DmxP512(parent, universeSize, false);
     dmxOutput.setupDmxPro(port, DMXPRO_BAUDRATE);
     inUse = true;
     for(int i = 0; i < 30; i++) { chInUse[i] = true; }
     for(int i = 100; i < 150; i++) { chInUse[i] = true; }
     reset();
    }
    catch (Exception e) {
     e.printStackTrace();
     inUse = false;
    }
  }
  
  
  void draw() { if(inUse) sendUniversum(); }
  
  void sendUniversum() {
    if(lastDMX.length != DMXforOutput.length) { lastDMX = new int[DMXforOutput.length]; }
    for(int i = 1; i < DMXforOutput.length; i++) {
      int newVal = DMXforOutput[i];
      if(newVal != lastDMX[i]) {
        sendChannel(i, newVal);
        lastDMX[i] = newVal;
      }
    }
  }
  
  void reset() { sendChannel(1, 255); sendChannel(1, 0); }
  
  void fullOn() { for(int i = 1; i <= 512; i++) if(chInUse[i]) setChannel(i, 255); }
  void blackout() { for(int i = 1; i <= 512; i++) if(chInUse[i]) setChannel(i, 0); }
  
  void setChannel(int ch, int val) {
    if(ch >= 0 && ch < DMXforOutput.length && val >= 0 && val <= 255) {
      DMXforOutput[ch] = val;
    }
  }
  
  void sendChannel(int ch, int val) {
    dmxOutput.set(ch, val);
  }
}