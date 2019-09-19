/**
 * Processing Sound Library, Example 4
 * 
 * Five soundfiles are mapped to the numbers on the keyboard. 
 * Numbers 1-5 are played back an octave lower and numbers
 * 6-0 an octave higher.
 */

import processing.sound.*;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;

Looper lpr;
Sound s;
SoundFile[] file, file2;

SoundFile currentDrum;
SoundFile currentMelody;

// settings
boolean looping = true;  // whether sounds will loop
int loopDuration = 7000; // loop duration in ms
boolean exclusive = true; // whether only one sound of a category is allowed 

int red, green, blue;

class Looper {
  float loopDur, lastMs = 0;
  HashMap<String,SoundFile> soundMap = new HashMap<String,SoundFile>();
  
  float speed = 1.0, volume = 1.0;
  
  
  Looper(int lD) {
    loopDur = lD;
  }
  
  // update the looper
  void update() {
    float now = millis();
    // loop over
    if (now - lastMs >= loopDur) {
      lastMs = now;
      Iterator it = soundMap.keySet().iterator();
      while (it.hasNext()) {
        String cat = (String) it.next(); // next category
        play(soundMap.get(cat));
      }
    }
    
  }
  
  // play a SoundFile with standard settings
  void play(SoundFile soundFile) {
    soundFile.play(speed, volume);
  }
  
  // Registers the current sound of a category
  // eg. registerSound("drums", sound);
  void registerSound(String category, SoundFile sound) {
      soundMap.put(category, sound);
  }
}

void setup() {
  size(640, 360);
  background(255);
  lpr = new Looper(loopDuration);

  // Create an AudioDevice with low buffer size 
  // and create an array containing 5 empty soundfiles
  //device = new AudioDevice(this, 48000, 32);
  s = new Sound(this);
  file = new SoundFile[5];
  file2 = new SoundFile[5];
  
  String[] melodyFiles = {"PS - die young 133 BPM", "PS - lose my number 140 BPM", "PS - the saddest waterfall 140 BPM" };
  String[] drumFiles = {"140 #1", "140 #8", "140 #10"};

  // Load 5 soundfiles from a folder in a for loop. 
  for (int i = 0; i < melodyFiles.length; i++) {
    file[i] = new SoundFile(this, melodyFiles[i] + ".wav");
  }
  
  // Load 5 soundfiles from a folder in a for loop. 
  for (int i = 0; i < drumFiles.length; i++) {
    file2[i] = new SoundFile(this, drumFiles[i] + ".wav");
  }
}

void draw() {
  background(red, green, blue);
  lpr.update();
}

void playDrum(SoundFile sf) {
  if (currentDrum != null) currentDrum.stop();
  sf.play(1, 1);
}

void playMelody(SoundFile sf) {
  if (currentDrum != null) currentDrum.stop();
  sf.play(1, 1);
}


void keyPressed() {
  // Set a random background color each time you hit then number keys
  red=int(random(255));
  green=int(random(255));
  blue=int(random(255));

  // Assign a sound to each number on your keyboard. 1-5 play at
  // an octave below the original pitch of the file, 6-0 play at
  // an octave above.
  switch(key) {
    case '1':
      //file[0].play(1, 1.0);
      lpr.registerSound("melody", file[0]);
      break;
    case '2':
      //file[1].play(1, 1.0);
      lpr.registerSound("melody", file[1]);
      break;
    case '3':
      lpr.registerSound("melody", file[2]);
      break;
    case '4':
      lpr.registerSound("drums", file2[0]);
      break;
    case '5':
      lpr.registerSound("drums", file2[1]);
      break;
    case '6':
      lpr.registerSound("drums", file2[2]);
      break;
  }
}