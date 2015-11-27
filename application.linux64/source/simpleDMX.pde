EnttecOutput enttecOutput;
Slider[] sliders = new Slider[513];

void setup() 
{
  size(1000, 200);
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
void draw() {
  background(0);
  if(setupDone) { sliders(); }
  else { setupWindow(); }
  if(enttecOutput != null) { enttecOutput.draw(); }
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


void keyPressed() {
  if(key == 'f') { if(enttecOutput != null) enttecOutput.fullOn(); }
  if(key == 'b') { if(enttecOutput != null) enttecOutput.blackout(); }
  if(keyCode == UP) if(setupDone) offset = getNext(offset, 0, 512/24);
  if(keyCode == DOWN) if(setupDone) offset = getReverse(offset, 0, 512/24);
}




