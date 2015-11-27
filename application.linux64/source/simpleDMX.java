import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import dmxP512.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class simpleDMX extends PApplet {

EnttecOutput enttecOutput;
Slider[] sliders = new Slider[513];

public void setup() 
{
 
  println(Serial.list());
  for(int i = 0; i < sliders.length; i++) {
    sliders[i] = new Slider();
    
  }
  frameRate(600);
}

boolean keyReleased = true;
int selected = 0;
boolean setupDone = false;
int offset = 0;
public void draw() {
  background(0);
  if(setupDone) { sliders(); }
  else { setupWindow(); }
  if(enttecOutput != null) { enttecOutput.draw(); }
}




public int getNext(int val, int lo, int hi) {
  if(val >= lo && val <= hi) val++;
  if(val > hi || val < lo) val = lo;
  return val;
}

public int getReverse(int val, int lo, int hi) {
  if(val >= lo && val <= hi) val--;
  if(val < lo || val > hi) val = hi;
  return val;
}


public void keyPressed() {
  if(key == 'f') { if(enttecOutput != null) enttecOutput.fullOn(); }
  if(key == 'b') { if(enttecOutput != null) enttecOutput.blackout(); }
  if(keyCode == UP) if(setupDone) offset = getNext(offset, 0, 512/24);
  if(keyCode == DOWN) if(setupDone) offset = getReverse(offset, 0, 512/24);
}





int[] DMXforOutput = new int[513];




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
  
  
  public void draw() { if(inUse) sendUniversum(); }
  
  public void sendUniversum() {
    if(lastDMX.length != DMXforOutput.length) { lastDMX = new int[DMXforOutput.length]; }
    for(int i = 1; i < DMXforOutput.length; i++) {
      int newVal = DMXforOutput[i];
      if(newVal != lastDMX[i]) {
        sendChannel(i, newVal);
        lastDMX[i] = newVal;
      }
    }
  }
  
  public void reset() { sendChannel(1, 255); sendChannel(1, 0); }
  
  public void fullOn() { for(int i = 1; i <= 512; i++) if(chInUse[i]) setChannel(i, 255); }
  public void blackout() { for(int i = 1; i <= 512; i++) if(chInUse[i]) setChannel(i, 0); }
  
  public void setChannel(int ch, int val) {
    if(ch >= 0 && ch < DMXforOutput.length && val >= 0 && val <= 255) {
      DMXforOutput[ch] = val;
    }
  }
  
  public void sendChannel(int ch, int val) {
    dmxOutput.set(ch, val);
  }
}

public void setupWindow() {
    
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
class Slider {
  
  Slider() {
   
  }
  public void setup() {
  }
   int value = 0;
   boolean changeValue = false;
  public void draw(PVector location, int number) {
    
    PVector size = new PVector(30, 100);
    strokeWeight(2); stroke(100);
    fill(255);
    rect(location.x, location.y, size.x, size.y);
    text(number, location.x, location.y+size.y+20);
    text(value, location.x, location.y+size.y+20+20);
    if(mousePressed && mouseX > location.x && mouseX < location.x+size.x && mouseY >= location.y && mouseY <= location.y + size.y + 40) {
      changeValue = true;
    }
    if(!(mouseX > location.x && mouseX < location.x+size.x && mousePressed)) {
      changeValue = false;
    }
    if(changeValue) {
      value = constrain(PApplet.parseInt(map(size.y-mouseY+location.y, 0, size.y, 0, 255)), 0, 255);
    }
    stroke(150);
    fill(100);
    rect(location.x+1, -map(value, 0, 255, 0, size.y)+size.y+location.y, size.x-2, map(value, 0, 255, 0, size.y));
    
  }
}
public void sliders() {
  for(int i = 0; i < 24; i++) {
      if(i + offset*24 + 1 <= 512) {
        int ch = i + 1;
        sliders[i+offset*24].draw(new PVector(i*40+20, 10), ch+offset*24);
        if(enttecOutput != null) if(sliders[i+offset*24].changeValue) { enttecOutput.setChannel(ch+offset*24, sliders[i+offset*24].value); }
        if(enttecOutput != null) sliders[i+offset*24].value = DMXforOutput[ch+offset*24];
      }
    }
}
  public void settings() {  size(1000, 200); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "simpleDMX" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
