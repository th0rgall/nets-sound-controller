

import processing.serial.*;
import processing.sound.*;
import java.util.Map;
import java.util.Set;
import java.util.Iterator;

Serial sPort;  // Create object from Serial class
String val;     // Data received from the serial port

// MUSIC LOOPER SETTINGS
Looper lpr;
Sound s;
SoundFile[] melodyFiles = new SoundFile[5];
SoundFile[] drumFiles = new SoundFile[5];
String[] melodyStrings = {"PS - die young 133 BPM", "PS - lose my number 140 BPM", "PS - the saddest waterfall 140 BPM" };
String[] drumStrings = {"140 #1", "140 #8", "140 #10"};

SoundFile currentDrum;
SoundFile currentMelody;

// settings
boolean looping = true;  // whether sounds will loop
int loopDuration = 7000; // loop duration in ms
boolean exclusive = true; // whether only one sound of a category is allowed 

// MODEL SETTINGS

Object[][] constructModel(int mWidth, int mHeight) {
  Object[][] model = new Object[mWidth][mHeight];
  // initialize
  for (Object[] vertical : model) {
    for (int i = 0; i < vertical.length; i++) {
      vertical[i] = new Boolean(false);
    }
  }
  return model;
}

// TEST SETTINGS
int start = -1;

//Boolean[][] capModel = (Boolean[][]) constructModel(2,2);
//SoundFile[][] soundModel = (SoundFile[][]) constructModel(2,2);
// Boolean[][] lightModel = (Boolean[][]) constructModel(2,2);
Boolean[][] capModel = {{false, false}, {false, false}};
SoundFile[][] soundModel = {{null, null}, {null, null}};


// VISUAL COMPUTER SETTINGS
int red, green, blue;

// LOOPER CODE 

class Looper {
  float loopDur, lastMs = 0;
  HashMap<String, SoundFile> liveMap = new HashMap<String, SoundFile>();
  HashMap<String, SoundFile> fixedMap = new HashMap<String, SoundFile>();


  float speed = 1.0, volume = 1.0;


  Looper(int lD) {
    loopDur = lD;
  }

  // get the remaining loopt time in ms
  float getElapsedLoopTime() {
    return millis() - lastMs;
  }

  // get remaining loop time in ms
  float getRemainingTime() {
    return loopDur - getElapsedLoopTime();
  }
  // update the looper
  void update() {
    float now = millis();
    // loop over
    if (now - lastMs >= loopDur) {
      lastMs = now;

      // loop through to-play map 
      Iterator it = liveMap.keySet().iterator();
      // assumed live will always have more info than previous fixe
      while (it.hasNext()) {
        String cat = (String) it.next(); // next category
        SoundFile sF = liveMap.get(cat); 
        if (sF != null) { // if not null, play or repeat
          sF.stop();
          sF.cue(0);
          play(liveMap.get(cat)); // play new sound
        }
      }
      
      // reset capmodel
      for (int i = 0; i < capModel.length; i++) {
        for (int j = 0; j < capModel.length; j++) {
          capModel[i][j] = false;
        }
      }
    }
  }

  // play a SoundFile with standard settings
  void play(SoundFile soundFile) {
    if (soundFile != null) soundFile.play(speed, volume);
  }

  // Registers the current sound of a category
  // eg. registerSound("drums", sound);
  // null will disable the sound
  void registerSound(String category, SoundFile sound) {
    // check for jumpstart possibility - start immediately if no currently playing song
    if (liveMap.get(category) != sound && liveMap.get(category) != null) { // if not already there (else stay looping)
      liveMap.get(category).stop();
      liveMap.get(category).cue(0);
    }
    
    if (liveMap.get(category) != sound) {
      liveMap.put(category, sound);
      float cueTime = getElapsedLoopTime()/1000;
      if (cueTime < sound.duration()) {
        sound.cue(cueTime);
        play(sound);
      }
    }
  }
  
  void deregisterSound(String category, SoundFile sound) {
    if (liveMap.get(category) != null && liveMap.get(category) == sound) {
      SoundFile sf = liveMap.get(category);
      sf.stop();
      liveMap.put(category, null);
    }
  }
  
  
  // class }
}

// SETUP 

void setup() {
  size(640, 360);
  background(255);
  lpr = new Looper(loopDuration);

  // Create an AudioDevice with low buffer size 
  // and create an array containing 5 empty soundfiles
  //device = new AudioDevice(this, 48000, 32);
  s = new Sound(this);

  // Load 5 soundfiles from a folder in a for loop. 
  for (int i = 0; i < melodyStrings.length; i++) {
    melodyFiles[i] = new SoundFile(this, melodyStrings[i] + ".wav");
  }

  // Load 5 soundfiles from a folder in a for loop. 
  for (int i = 0; i < drumStrings.length; i++) {
    drumFiles[i] = new SoundFile(this, drumStrings[i] + ".wav");
  }

  // -------- LOAD model

  soundModel[0][0] = drumFiles[0];
  soundModel[0][1] = drumFiles[2];
  soundModel[1][0] = melodyFiles[0];
  soundModel[1][1] = melodyFiles[1];

  // -------- SETUP serial

  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  //String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  
  String portName = "/dev/tty.usbmodem145301";
  //sPort = new Serial(this, portName, 9600);
  delay(1000);
  
  //sPort.buffer(3);
  
  // -------- SETUP test
  
  start = millis();
  
}


void draw() {
//  if ( sPort.available() > 0) 
// {  // If data is available,
//    val = sPort.readStringUntil('\n'); // read it and store it in val
//  } 

  // println(val); //print it out in the console
  
  // ---- read model and adjust soundModel ----
  for (int i = 0; i < capModel.length; i++) {
    for (int j = 0; j < capModel.length; j++) {
            
      // activate selectively
      if (capModel[i][j] == true) {
        lpr.registerSound(Integer.toString(i), soundModel[i][j]);
      } else {
        lpr.deregisterSound(Integer.toString(i), soundModel[i][j]);
  
      }
    }
  }

  background(red, green, blue);
  lpr.update();
  textSize(32);
  text(Float.toString(lpr.getRemainingTime()), width/2, height/2);
}


// READ EVENTS 

// protocol with 255 bytes:
// row
// column
// on/off (1/0) (capacitive)
void serialEvent(Serial se) {
  //if ( se.available() > 0) 
  //{  // If data is available,
  //  val = se.readStringUntil('\n'); // read it and store it in val

  //}
  if (se != null) {
    while (se.available() >= 3) {
      int column = se.read();
      int row = se.read();
      int on = se.read();
      println("IN:");
      println(column, row, on);
  
      // change on model
      setModel(column, row, (on == 1) ? true : false);
    }
  }
}

void setModel(int col, int row, Boolean value) {
  // reset all lalala
  for (int i = 0; i < capModel[col].length; i++) {
    capModel[col][i] = false;
  }
  // change
  capModel[col][row] = value;
}


void keyPressed() {
  // Set a random background color each time you hit then number keys
  if (key >= 0 && key <= 4) {
    red=int(random(255));
    green=int(random(255));
    blue=int(random(255));
  }

  // Assign a sound to each number on your keyboard. 1-5 play at
  // an octave below the original pitch of the file, 6-0 play at
  // an octave above.
  switch(key) {
  case '1':
    //melodyFiles[0].play(1, 1.0);
    //lpr.registerSound("melody", melodyFiles[0]);
    setModel(0, 0, true);
    break;
  case '2':
    //melodyFiles[1].play(1, 1.0);
    //lpr.registerSound("melody", melodyFiles[1]);
    setModel(0, 1, true);
    break;
  case '3':
    //lpr.registerSound("melody", melodyFiles[2]);
    setModel(1, 0, true);
    break;
  case '4':
    //lpr.registerSound("drums", drumFiles[0]);
    setModel(1, 1, true);
    break;
  //case '5':
  //  lpr.registerSound("drums", drumFiles[1]);
  //  break;
  //case '6':
  //  lpr.registerSound("drums", drumFiles[2]);
  //  break;
  }

void keyReleased() {
  // Set a random background color each time you hit then number keys
  if (key >= 0 && key <= 4) {
    red=int(random(255));
    green=int(random(255));
    blue=int(random(255));
  }

  // Assign a sound to each number on your keyboard. 1-5 play at
  // an octave below the original pitch of the file, 6-0 play at
  // an octave above.
  switch(key) {
  case '1':
    //melodyFiles[0].play(1, 1.0);
    //lpr.registerSound("melody", melodyFiles[0]);
    setModel(0, 0, false);
    break;
  case '2':
    //melodyFiles[1].play(1, 1.0);
    //lpr.registerSound("melody", melodyFiles[1]);
    setModel(0, 1, false);
    break;
  case '3':
    //lpr.registerSound("melody", melodyFiles[2]);
    setModel(1, 0, false);
    break;
  case '4':
    //lpr.registerSound("drums", drumFiles[0]);
    setModel(1, 1, false);
    break;
  //case '5':
  //  lpr.registerSound("drums", drumFiles[1]);
  //  break;
  //case '6':
  //  lpr.registerSound("drums", drumFiles[2]);
  //  break;
  }
}