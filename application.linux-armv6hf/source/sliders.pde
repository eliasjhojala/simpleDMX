void sliders() {
  for(int i = 0; i < 24; i++) {
      if(i + offset*24 + 1 <= 512) {
        int ch = i + 1;
        sliders[i+offset*24].draw(new PVector(i*40+20, 10), ch+offset*24);
        if(enttecOutput != null) if(sliders[i+offset*24].changeValue) { enttecOutput.setChannel(ch+offset*24, sliders[i+offset*24].value); }
        if(enttecOutput != null) sliders[i+offset*24].value = DMXforOutput[ch+offset*24];
      }
    }
}