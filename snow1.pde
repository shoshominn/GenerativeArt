import processing.sound.*;
AudioIn mic;
Amplitude amp;

Snow[] snows = new Snow[100];

int light_position_x;
int light_position_y;
int light_power = 3;
int red_power = 100;
int green_power = 100;
int blue_power = 255;
int state = 0;
int nextstate = 0;

void setup() {
  size(640, 480);
  mic = new AudioIn(this, 0);
  mic.start();
  amp = new Amplitude(this);
  amp.input(mic);
  for (int i=0; i<snows.length; i++) {
    Snow snow = new Snow();
    snow.x = random(0, 640);
    snow.y = 0;
    snows[i] = snow;
  }
}

boolean fig = false;
void draw() {

  background(0);

  for (int i=0; i<snows.length; i++) {
    if (i<(frameCount /10)) {

      if (state == 0) { 
        snows[i].disp0();//OFF
        snows[i].fall0();//OFF
        nextstate = ON();
      } else if (state == 1) {
        snows[i].disp1(); //ON   
        snows[i].fall1(); //ON      
        nextstate = OFF();
        if (nextstate == 0) {
          light_power = 0;
        }
        snows[i].disp0();//OFF
        snows[i].fall0();
      }
    }
    state = nextstate;
  }
}


class Snow {
  float x;
  float y;

  void disp0() {
    fill(200, 200, 200, 200);
    noStroke();
    ellipse(x, y, 10, 10);
  }

  void disp1() {

    int red_power = int(random(255));
    int green_power = int(random(255));
    int blue_power = int(random(255));
    light_position_x = int(x);
    light_position_y= int(y);
    loadPixels();
    for (int y=0; y<height; y++) {
      for (int x=0; x<width; x++) {
        int pixelIndex = x+y*width;
        int r = pixels[pixelIndex]>>16 & 0xFF;
        int g = pixels[pixelIndex]>>8 & 0xFF;
        int b = pixels[pixelIndex] & 0xFF;
        float dx = light_position_x - x;
        float dy = light_position_y - y;
        float distance = sqrt(dx * dx + dy * dy);

        if (distance < 1) {
          distance = 1;
        }

        r += (red_power * light_power)/distance;
        g += (green_power * light_power)/distance;
        b += (blue_power * light_power)/distance;

        pixels[pixelIndex] = color(r, g, b);
      }
    }
    updatePixels();
  } 

  void fall0() {
    y = y+1;
  }
  void fall1() {
    y = y+1;
  }
}

int ON() {
  float Volume = map(amp.analyze(), 0, 1, 10, width);
  if (Volume>60) { 
    return 1;
  } else return 0;
}
int OFF() {
  float Volume = map(amp.analyze(), 0, 1, 10, width);
  if (Volume>40) { 
    return 0;
  } else return 1;
}