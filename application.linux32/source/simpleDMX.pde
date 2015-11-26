/**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port. 
 * This example works with the Wiring / Arduino program that follows below.
 */


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
void draw() {
  
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
      println(selected);
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

