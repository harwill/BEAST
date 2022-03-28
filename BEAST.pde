//Libraries -----------------------------------------------------
import processing.opengl.*;
import processing.serial.*;
import toxi.geom.*;
import toxi.processing.*;
import peasy.*;
//import net.java.games.input.*;
//import cc.arduino.*;
import controlP5.*;


//Object Declarations -------------------------------------------
ToxiclibsSupport gfx;
String[] split_data;
Serial Port;  
PeasyCam cam;
ArmJoint ArmJoint;
Textlabel title;

//Variables -----------------------------------------------------

int read_interval = 0;
PVector cam_position;
ArrayList<ArmJoint> robots = new ArrayList<ArmJoint>();
float angle_xy = 0;
float distance_xy = 0;

void setup(){
  
  //Program Window 
  size(1920,1080,OPENGL);
  
  // List all the available serial ports:
  printArray(Serial.list());
  
  // Select Com Port
  //COM4 in this case              here V
  Port = new Serial(this, Serial.list()[4], 9600); // Make sure there are no serial terminals open
  
  // Declare New Objets 
  ArmJoint = new ArmJoint();
 
  // Virtual camera setting 
  cam = new PeasyCam(this, 500); // start zoom
  cam.setMinimumDistance(50); // min/max Zoom in with scroll distance 
  cam.setMaximumDistance(600); 
  float fov     = PI/4;  // field of view
  float nearClip = 1; // how close items go out field of viewf
  float farClip  = 100000; // how far items go out field of view
  float aspect   = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip); 
  
}

void draw() {
  //         R   G    B
  background(26, 28, 35);
  
  read_serial();
  
  
  ArmJoint.move_joint();
  ArmJoint.draw_joint();
  
  // Items in HUD are still and will not rotate with 3D axis 
  cam.beginHUD();
  //Axis frame
  strokeWeight(0);
  
  // Draws blocking rectangles to make a frame around the 3D axis from going over rest of the HUD
  pushMatrix();
  hudFrame(); 
  popMatrix();
  
  cam.endHUD();

  
}

void read_serial(){
  // Reads Serial port data containing IMU and Encoder values every 10 ms
  if (millis() - read_interval > 10) {
    read_interval = millis();
    if (Port.available() > 0) {
      String read_data = Port.readString();
       
      // Protects against null pointer eexception error, incase reads serial data incorrectly
      if(read_data != null){
        split_data = split(read_data, ' ');
        println(read_data);
      }
    }
  }
}


void hudFrame(){
  // top bar
  stroke(26, 28, 35);
  fill(26, 28, 35);
  rect(0, 0, 1920, 200);

  // left bar
  stroke(26, 28, 35);
  fill(26, 28, 35);
  rect(0, 0, 600, 1100);

  // bright bar
  pushMatrix();
  translate(1320, 0, 0);
  stroke(26, 28, 35);
  fill(26, 28, 35);
  rect(0, 0, 600, 1100);
  popMatrix();

  // top bar
  pushMatrix();
  translate(0, 840, 0);
  stroke(26, 28, 35);
  fill(26, 28, 35);
  rect(0, 0, 1920, 340);
  popMatrix();
  
  // frame
  translate(600, 200, 0);
  strokeWeight(3);
  stroke(46,48,62);
  noFill();
  rect(0, 0, 720, 640) ;

  // endoscope camera frame
  translate(740, 0, 0);
  strokeWeight(3);
  stroke(46,48,62);
  noFill();
  rect(0, 0, 570, 433) ;
}
