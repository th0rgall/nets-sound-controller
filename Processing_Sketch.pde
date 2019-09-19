/**
 * Processing Sound Library, Example 4
 * 
 * Five soundfiles are mapped to the numbers on the keyboard. 
 * Numbers 1-5 are played back an octave lower and numbers
 * 6-0 an octave higher.
 */

import processing.sound.*;

Sound s;
SoundFile[] file, file2;

SoundFile currentDrum;
SoundFile currentMelody;

int red, green, blue;

void setup() {
  size(640, 360);
  background(255);

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
    file[0].play(1, 1.0);
    break;
  case '2':
    file[1].play(1, 1.0);
    break;
  case '3':
    file[2].play(1, 1.0);
    break;
  case '4':
    file2[0].play(1, 1.0);
    break;
  case '5':
    file2[1].play(1, 1.0);
    break;
  case '6':
    file2[3].play(1, 1.0);
    break;
  case '7':
    file[1].play(2.0, 1.0);
    break;
  case '8':
    file[2].play(2.0, 1.0);
    break;
  case '9':
    file[3].play(2.0, 1.0);
    break;
  case '0':
    file[4].play(2.0, 1.0);
    break;
  }
}