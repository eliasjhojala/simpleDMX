
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