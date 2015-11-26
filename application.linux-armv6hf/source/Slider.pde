class Slider {
  
  Slider() {
   
  }
  void setup() {
  }
   int value = 0;
  void draw(PVector location, int number) {
    
    PVector size = new PVector(30, 100);
    strokeWeight(2); stroke(100);
    fill(255);
    rect(location.x, location.y, size.x, size.y);
    text(number, location.x, location.y+size.y+20);
    text(value, location.x, location.y+size.y+20+20);
    if(mousePressed && mouseX > location.x && mouseX < location.x+size.x && mouseY >= location.y && mouseY <= location.y + size.y) {
      value = int(map(size.y-mouseY+location.y, 0, size.y, 0, 255));
    }
    stroke(150);
    fill(100);
    rect(location.x+1, -map(value, 0, 255, 0, size.y)+size.y+location.y, size.x-2, map(value, 0, 255, 0, size.y));
    
  }
}