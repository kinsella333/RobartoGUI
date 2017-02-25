import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FinalProjectGUI extends PApplet {

/**
 *CPRE 288 final project
 *GUI for visually the robots position
 */





boolean DEMO = true;


//Robot object
Robot robot;

//list of obstacles detected
ArrayList<Obstacle> obstacles;
int num_objs;
int parsedObjects;
boolean scanned_init = false;
//record of robot position
ArrayList<Point> trail=  new ArrayList<Point>();

//world varables
int window_size = 800; //pixels
int world_size = 500; //cm
float pixels_per_cm = window_size * 1.0f / world_size;

int roomba_size = 33; //cm diameter

//show or hide status and button bars
boolean status_enabled = true;
boolean buttons_enabled = true;
boolean popup_enabled = false;
boolean trail_enabled = true;
String popup_text = "";
Kueue popupBuffer;

//font for UI text
PFont font;
PFont font_big;


//pending commands to send to robot
int move_cmd = 0;
int turn_cmd = 0;
String last_cmd = "null";

//last time the robot RESPONDED to a status request
int last_status_update = 0;
boolean is_alive = true; //robots last response


int parseType = -1;
int parse_start_time = 0;

//buttons for the UI
Button f1, f5, f10, b1, b5, b10, r1, r15, r45, r90, l1, l15, l45, l90, resend, req_stat, scan, exec, vic;

Serial port;
Kueue SerialBuffer;



public void setup() {

  //create window
  
  

  //specify font
  font = createFont("Segoe UI", 15);
  font_big = createFont("Segoe UI", 35);

  //load buttons
  create_buttons();

  //create robot
  robot = new Robot(roomba_size, new Point(0, 0), 45);

  //create obstacle list
  obstacles = new ArrayList<Obstacle>();

  //create trail list
  trail.add(new Point(0,0));



  if(DEMO){
   trail.add(new Point(0,0));
   trail.add(new Point(-40,0));
   trail.add(new Point(-40,-40));
   trail.add(new Point(-80,-80));

    for(int i = 0; i < 10; i++){
    Point p = new Point(random(-80, 80),random(-80, 80));

    obstacles.add(new Obstacle(p, (int)random(5, 45), (int)random(4)));
    }

  }
  if(!DEMO){
      port = new Serial(this, "COM4", 38400);
      SerialBuffer = new Kueue();
  }



}

public void draw() {
  background(52);


  if(!DEMO){
    //check for info from robot

    while(port.available() > 0){
        char c = port.readChar();
        SerialBuffer.enkueue(c);
    }

    if(parseType != -1){
      if(millis() - parse_start_time > 1000){
        parseError();
      }else{
        parse_uart();
      }
    }
    else if(SerialBuffer.size() > 0){
      //SerialBuffer.prnt();
      char type = SerialBuffer.dekueue();
      print((int)type);
      //SerialBuffer.prnt();
      start_parse(type);
    }


  }

  //calculate scale
  pixels_per_cm = window_size * 1.0f / world_size;

  //draw grid with 15cm spacing
  draw_grid(15);

  //focus on robot
  float focus_x = robot.pos.x * pixels_per_cm * -1;
  float focus_y = robot.pos.y * pixels_per_cm;
  translate(focus_x, focus_y);

  draw_obstacles();

  if (trail_enabled) {
    draw_trail();
  }

  //draw new position
  draw_path();

  //draw robot
  robot.show();

  //Focus on screen, not world
  resetMatrix();
  if (status_enabled) {
    draw_status();
  }
  if (buttons_enabled) {
    draw_buttons();
  }


  if (popup_enabled) {
    draw_popup();
  }
}




public void mouseClicked() {

  //button bar
  if (buttons_enabled) {

    //move buttons
    if (b10.check_click()) {
      move_cmd -=10;
      return;
    }
    if (b5.check_click()) {
      move_cmd -=5;
      return;
    }
    if (b1.check_click()) {
      move_cmd -=1;
      return;
    }
    if (f1.check_click()) {
      move_cmd +=1;
      return;
    }
    if (f5.check_click()) {
      move_cmd +=5;
      return;
    }
    if (f10.check_click()) {
      move_cmd +=10;
      return;
    }
    //turn buttons
    if (l45.check_click()) {
      turn_cmd -=45;
      return;
    }
    if (l15.check_click()) {
      turn_cmd -=15;
      return;
    }
    if (l1.check_click()) {
      turn_cmd -=1;
      return;
    }
    if (r1.check_click()) {
      turn_cmd +=1;
      return;
    }
    if (r15.check_click()) {
      turn_cmd +=15;
      return;
    }
    if (r45.check_click()) {
      turn_cmd +=45;
      return;
    }


    //send command
    if (exec.check_click()) {

      //turn and move
      if (turn_cmd != 0 && move_cmd != 0) {
        command_turn(turn_cmd);
        command_movement(move_cmd);
        last_cmd = "turn(" + turn_cmd + ") and move(" + move_cmd + ")";
      }
      //turn
      else if (turn_cmd != 0) {
        command_turn(turn_cmd);
        last_cmd = "TURN(" + turn_cmd + ")";
      }
      //move
      else if (move_cmd != 0) {
        command_movement(move_cmd);
        last_cmd = "MOVE(" + move_cmd + ")";
      }

      move_cmd = 0;
      turn_cmd = 0;
      return;
    }

    //scan command
    if (scan.check_click()) {

      command_scan();
      last_cmd = "SCAN";
      return;
    }
    //victory command
    if(vic.check_click()){
      command_victory();
      last_cmd = "VICTORY";
      return;
    }
  }

  //status bar
  if (status_enabled) {
    //status command
    if (req_stat.check_click()) {
      request_status();
      last_cmd = "REQUEST STATUS";
      return;
    }

    //resend command
    if (resend.check_click()) {
      request_last_message();
      last_cmd = "REQUEST LAST MESSAGE";
      return;
    }
  }

  //click to remove an obstacle
  for(int i = 0; i < obstacles.size(); i++){
    if(obstacles.get(i).check_HoverOver()){
       obstacles.remove(i);
        break;
    }
  }

}






public void keyPressed() {
  if (key == 's') {
    status_enabled = !status_enabled;
  }
  if (key == 'b') {
    buttons_enabled = !buttons_enabled;
  }
  if (key == 'c') {
    popup_enabled = !popup_enabled;
    popup_text = "";
  }
  if (key == 't') {
    trail_enabled = !trail_enabled;
  }
}


public void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  world_size = max(world_size + (int)(50 * e), 300);
  world_size = min(world_size + (int)(50 * e), 4500);
}



class Char{
  char c;
  Char(char c){
   this.c = c;
  }
  
  Char(){
  }
  
  public char get(){
    return c;
  }
  
  public void set(char c){
    this.c = c;
  }
}


///////////////////////////////////////////////////////////////////COMMANDS////////////////////////////////////////////////////////

public void request_status() {
  byte msg;
  msg = 3; //type
  port.write(msg);
}

public void request_last_message() {
  byte msg;
  msg = 4; //type
  port.write(msg);
}

public void command_movement(int movement) {
  int speed = 200;


  byte[] msg = new byte[5];
  msg[0] = 0; //type
  msg[1] = PApplet.parseByte((movement & 0xFF00) >> 8) ; //distance  0
  msg[2] = PApplet.parseByte(movement & 0x00FF);    //10
  msg[3] = PApplet.parseByte(speed >> 8); //speed of motors //0
  msg[4] = PApplet.parseByte(speed & 0x00FF);  //200
  
  write_msg(msg,5);
}

public void command_turn(int rotation) {

  int speed = 100;

  byte[] msg = new byte[5];
  msg[0] = 1; //type
  msg[1] = PApplet.parseByte((rotation & 0xFF00) >> 8); //angle
  msg[2] = PApplet.parseByte(rotation & 0xFF);
  msg[3] = PApplet.parseByte(speed >> 8); //speed of motors
  msg[4] = PApplet.parseByte(speed & 0x00FF);

   write_msg(msg,5);
}

public void command_scan() {
  byte msg;
  msg = 2; //type
  port.write(msg);
}

public void command_victory(){
    byte msg;
  msg = 5; //type
  port.write(msg);
  
  
}


///////////////////////////////////////////////////////////////MESSSAGES////////////////////////////////////////////////

public void parse_bumper() {
 if(SerialBuffer.size() > 1){
   
  char[] msg = new char[2];

  read_chars(msg, 2);
  
    String type_text = "null"; //text representation of bumper location
    int side = 0; //angular location of bumper

    //parse location
    int type = parse_int(msg[0], msg[1]);
    if (type == 0) { //left
      side = 330;
      type_text = "left";
    }
    if (type == 1) { //right
      side = 30;
      type_text = "right";
    }


    //notify user
    popup_text += "BUMPER: " + type_text;
    popup_enabled = true;

    //calculate position
    Point loc = polar_to_robot(7 + (int)robot.size/2, side + (int)robot.heading);
    loc.x += robot.pos.x;
    loc.y += robot.pos.y;

    //add to map
    obstacles.add(new Obstacle(loc, 13, 1));
    
    parseType = -1;
  }
}


public void parse_status() {
  
  if(SerialBuffer.size() > 7){
  
  
      char[] msg = new char[8];
    
        read_chars(msg, 8);
    
    
        //parse message
        robot.pos.x = parse_int(msg[0], msg[1]);
        robot.pos.y = parse_int(msg[2], msg[3]);
        robot.heading = parse_int(msg[4], msg[5]);
        int status = parse_int(msg[6], msg[7]);
    
        if (status == 0) {
          robot.status = "Idle";
        }
        if (status == 1) {
          robot.status = "Moving";
        }
        if (status == 2) {
          robot.status = "Turning";
        }
        if (status == 3) {
          robot.status = "Scanning";
        }
    
        //add new location to trail
        trail.add(new Point(robot.pos.x,robot.pos.y));
    
        last_status_update = millis();
        
        parseType = -1;
  }
    
}

public void parse_scan() {
  
  //parse in an object
  if(scanned_init && SerialBuffer.size() > 3){ 
      char[] scan = new char[4];
      read_chars(scan, 4);
      char index = scan[0];
      char size = scan[1];
      char angle = scan[2];
      char distance = scan[3];

      //calculate location
      Point loc = polar_to_robot(5 + (int)distance, (int)(90 - angle + robot.heading));
      loc.x += robot.pos.x;
      loc.y += robot.pos.y;

      //add to map
       obstacles.add(new Obstacle(loc, size * 1.0f, 0));
       parsedObjects += 1;
       
       
       if(parsedObjects >= num_objs){ //endcase
         parseType = -1;
         scanned_init = false;
       }
    
  }
  //parse in number of objects available
  else if(SerialBuffer.size() > 1){
    
    char[] msg = new char[2];
     read_chars(msg, 2);
    //parse message
    num_objs = parse_int(msg[0], msg[1]);
    println(num_objs);
    parsedObjects = 0;
    scanned_init = true;
    if(num_objs == 0){
      parseType = -1;
      scanned_init = false;
    }
  }
  
  
}

public void parse_cliff() {
  
  if(SerialBuffer.size() > 1){
    char[] msg = new char[2];
  
    read_chars(msg, 2);
  
    
      String type_text = "null"; //text representation of cliff location
      int side = 0; //angular location of cliff
  
      //parse location
      int type = parse_int(msg[0], msg[1]);
      if (type == 0) { //left
        side = 300;
        type_text = "left";
      }
      if (type == 1) { //right
        side = 60;
        type_text = "right";
      }
      if (type == 2) { //front
        side = 0;
        type_text = "front";
      }
  
  
      //notify user
      popup_text += "CLIFF: " + type_text;
      popup_enabled = true;
  
      //calculate position
      Point loc = polar_to_robot(43 + (int)robot.size/2, side + (int)robot.heading);
      loc.x += robot.pos.x;
      loc.y += robot.pos.y;
  
      //add to map
      obstacles.add(new Obstacle(loc, 85, 2));
      
      parseType = -1;
  }
}

public void parse_wall() {
  
  if(SerialBuffer.size() > 1){
    char[] msg = new char[2];
  
    read_chars(msg, 2);
  
    
      String type_text = "null"; //text representation of wall location
      int side = 0; //angular location of wall
  
      //parse location
      int type = parse_int(msg[0], msg[1]);
      if (type == 0) { //left
        side = 300;
        type_text = "left";
      }
      if (type == 1) { //right
        side = 60;
        type_text = "right";
      }
      if (type == 2) { //front
        side = 0;
        type_text = "front";
      }
  
  
      //notify user
      popup_text += "WALL: " + type_text;
      popup_enabled = true;
  
      //calculate position
      Point loc = polar_to_robot(3 + (int)robot.size/2, side + (int)robot.heading);
      loc.x += robot.pos.x;
      loc.y += robot.pos.y;
  
      //add to map
      obstacles.add(new Obstacle(loc, 5, 3));
      
      parseType = -1;
  }
  
}


public void parse_marker(){
  
  if(SerialBuffer.size() > 1){
    char[] msg = new char[2];
  
    read_chars(msg, 2);
  
    
      String type_text = "null"; //text representation of marker location
      int side = 0; //angular location of marker
  
      //parse location
      int type = parse_int(msg[0], msg[1]);
      if (type == 0) { //left
        side = 300;
        type_text = "left";
      }
      if (type == 1) { //right
        side = 60;
        type_text = "right";
      }
      if (type == 2) { //front
        side = 0;
        type_text = "front";
      }
  
  
      //notify user
      popup_text += "MARKER: " + type_text;
      popup_enabled = true;
  
      //calculate position
      Point loc = polar_to_robot(8 + (int)robot.size/2, side + (int)robot.heading);
      loc.x += robot.pos.x;
      loc.y += robot.pos.y;
  
      //add to map
      obstacles.add(new Obstacle(loc, 15, 4));
      
      parseType = -1;
  }
   
}


////////////////////////////////////////////////////////////////////////////SERIAL CONTROL////////////////////////////////////////////////////////////////////////////

public int parse_int(char high, char low) {
  int c = (int)((high << 8) | low);
  if ((high & 0x80) >> 7 == 1) { //convert 2 byte int to 4 byte int
    c = c | (0xFFFF << 16);
  }
  return c;
}

public void read_chars(char[] msg, int size) {
  int index = 0;
  while (index < size) {
      msg[index] = SerialBuffer.dekueue();
      index++;
  } 
}


public void write_msg(byte[] msg, int size){
  for(int i = 0; i < 5; i++){
      port.write(msg[i]);
  }  
}

public void port_flush(){
 while(port.available() > 0){
  port.readChar();
 } 
  
}

/////////////////////////////////////////////////////////////////////////////////////MESSAGE DISPATCH/////////////////////////////////////////////////
public void parse_uart(){
    switch(parseType){
       case 0:
         parse_bumper();
       break;
       case 1:
         parse_cliff();
       break;
       case 2:
         parse_status();
       break;
       case 3:
          parse_scan();
       break;
       case 4:
          parse_wall();
       break; 
       case 6:
         parse_marker();
        break;
    }
}



public void parseError(){
      switch(parseType){
       case 0:
            popup_text += "BUMPER: Error, location unknown" ;
       break;
       case 1:
            popup_text += "CLIFF: Error, location unknown" ;
       break;
       case 2:
            popup_text += "CONTROL: Could not parse status message";
       break;
       case 3:
             popup_text += "CONTROL: Unable to parse scan";
       break;
       case 4:
            popup_text += "WALL: Error, location unknown" ;
       break; 
       case 5:
         popup_text += "ROBOT: Unable to parse '" + last_cmd + "'";
       break;
       case 6:
           popup_text += "MARKER: Error, location unknown" ;
       break;
            
    }
    popup_enabled = true;
    SerialBuffer.clear();
    port_flush();
    parseType = -1;
}


public void start_parse(char type) {


  switch(type) {
        //bumper
      case 0:
        parseType = 0;
        parse_start_time = millis();
        break;
        //cliff
      case 1:
        parseType = 1;
        parse_start_time = millis();
        break;
        //status
      case 2:
        parseType = 2;
        parse_start_time = millis();
        break;
        //scan result
      case 3:
        parseType = 3;
        parse_start_time = millis();
        break;
        //wall
      case 4:
        parseType = 4;
        parse_start_time = millis();
        break;
        //parse error
      case 5:
        parseType = 5;
        parseError();
        break;
        
      //marker
      case 6:
        parseType = 6;
        parse_start_time = millis();
      break;
  }
}









class Kueue{
 ArrayList<Char> list;
  
 Kueue(){
    list = new ArrayList<Char>();
 } 
  
 public char dekueue(){
    char c = list.get(0).get();
    for(int i = 0; i < list.size() - 1; i++){
       list.set(i,list.get(i+1));
    }
    list.remove(list.size() -1);
    return c;
 }  
  
  
 public void enkueue(char c){
    list.add(new Char(c));
 }
 
 public int size(){
     return list.size(); 
   
 }
 
 public void clear(){
  for(int i = 0; i < list.size(); i++){
     list.remove(i);
  } 
 }
 
 public void prnt(){
   for(int i = 0; i < list.size(); i++){
      print((int) list.get(i).get());
      print(" ,");
  }
   println();
 }
   
  
}
class Obstacle{
  
  
  float diameter; //cm
  Point pos; //cm
  int clr;
  String kind;
  
  Obstacle(Point pos, float diameter,int type){
    this.pos = pos;
    this.diameter = diameter;
    switch(type){
     case 0:
       clr = color(197,24,240);
       kind = "pillar";
      break;
     case 1:
       clr = color(241,247,49);
       kind = "bump";
      break;
     case 2:
       clr = color(49,247,204);
       kind = "hole";
      break; 
     case 3:
       clr = color(245,162,120);
       kind = "wall";
      break;
     case 4:
       clr = color(255);
       kind = "marker";
     break;
    }
  }
  
  public boolean check_HoverOver(){
    
    Point shift = new Point(pos.x - robot.pos.x, pos.y - robot.pos.y);
    
    Point screen = world_to_screen(shift);
    float dist = sqrt(pow(screen.x - mouseX,2) + pow(screen.y - mouseY,2));
    //near object on screen -> display size in cm
    if(dist <= 10){
      
        Point text = world_to_screen(pos);
      
        
        fill(52);
        noStroke();
        rect(text.x + 10, text.y-25, 40, 35);
        
        textSize(12);
        fill(clr);
        text(diameter, text.x + 10, text.y - 10);
        text(kind, text.x + 15, text.y+5);
        return true;
    }
    return false;
  }
  
  public void show(){
    float pix_diameter = diameter * pixels_per_cm;
    Point screen = world_to_screen(pos);
    
    shapeMode(CENTER);
    fill(clr);
    stroke(clr);
    ellipse(screen.x,screen.y,pix_diameter,pix_diameter);
  }
  
}
class Point{
  
  float x, y;
  
  Point(int x, int y){
   this.x = x * 1.0f;
   this.y = y * 1.0f; 
  }
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
  
}


class Robot{
    float size; //cm
    Point pos; //cm
    float heading; //degrees
    String status;
    PShape robot;
    
    
    Robot(float size, Point pos, float heading){
      //place on map
      this.size = size;
      set_all(pos,heading);
      set_status("null");
      
    }
    
    public void set_all(Point pos, float heading){
      set_position(pos);
      set_heading(heading);
    }
    
    public void set_position(Point pos){
      this.pos = pos;
      
    }
    
    public void set_heading(float heading){
     
      this.heading = heading;
      
    }
    
    public void set_status(String status){
     this.status = status; 
      
    }
    
    public void show(){

      //create robot shape
      PShape robot = createShape(GROUP);
  
      float pix_diameter = (size * pixels_per_cm);
      
      shapeMode(CENTER);
      fill(0);
      PShape circle = createShape(ELLIPSE, 0, 0, pix_diameter, pix_diameter);
      circle.setFill(color(0));
      circle.setStroke(color(0));
      
      PShape arc = createShape(ARC, 0, 0, pix_diameter, pix_diameter, 0 -.4f, PI + .4f,OPEN);
      arc.setFill(color(255));
      arc.setStroke(color(255));
      
      robot.addChild(circle);
      robot.addChild(arc);
      
      
        //convert cm to pixels
        Point pnt = world_to_screen(pos);
  
        translate(pnt.x, pnt.y);
        rotate(heading * PI /180);
        shape(robot);
    }

  
}
//methods used to create UI



public void draw_obstacles(){
  for(int i = 0; i < obstacles.size(); i++){
    obstacles.get(i).show();
    obstacles.get(i).check_HoverOver();
  }
}


//draw grid on map
public void draw_grid(int spacing){
  strokeWeight(1);
  //vertical lines
  int world_x = (int)robot.pos.x;
  float pix_x = world_to_screen(new Point(world_x,0)).x;
  while(pix_x > 0){
    stroke(150);
    line(pix_x,0,pix_x,window_size);
    world_x -= spacing;
    pix_x = world_to_screen(new Point(world_x,0)).x;
  }
  world_x = (int)robot.pos.x;
  pix_x = world_to_screen(new Point(world_x,0)).x;
  while(pix_x <= window_size){
    stroke(150);
    line(pix_x,0,pix_x,window_size);
    world_x += spacing;
    pix_x = world_to_screen(new Point(world_x,0)).x;
  }
  
  
  //Horizontal lines
  int world_y = (int)robot.pos.y;
  float pix_y = world_to_screen(new Point(0,world_y)).y;
  
  while(pix_y <= window_size){
    stroke(150);
    line(0,pix_y,window_size,pix_y);
    world_y -= spacing;
    pix_y = world_to_screen(new Point(0,world_y)).y;
  }
  world_y = (int)robot.pos.y;
  pix_y = world_to_screen(new Point(0,world_y)).y;
  while(pix_y > 0){
    stroke(150);
    line(0,pix_y,window_size,pix_y);
    world_y += spacing;
    pix_y = world_to_screen(new Point(0,world_y)).y;
  }
 
}


//draw status of vehicle at top of the screen
public void draw_status(){
  //draw status bar
  fill(212,210,210);
  noStroke();
  rect(0,0, window_size, 95);
    

  //set font
  textFont(font);

  //print status  
  fill(52);
  text("Status: " + robot.status, 10, 30); 
  
  
  //print position
  fill(52);
  text("x: " + robot.pos.x + " y: " + robot.pos.y + " heading: " + robot.heading, 10, 50); 
  
  
  //print last command
  fill(52);
  text("Last Command: " + last_cmd, 10, 70); 
  
  //print status button
  req_stat = new Button(490,10,100,30," request status",color(120,137,245));
  req_stat.show();
  fill(120,137,245);
  text("Last update " + (int)((millis() - last_status_update)/1000) + " seconds ago", 600, 30); 
  
  //print resend button
  resend = new Button(490,50,150,30,"  request last message",color(120,137,245));
  resend.show();

  
}

public void draw_buttons(){
  //draw button bar
  fill(212,210,210);
  noStroke();
  rect(0,window_size - 95, window_size, 95);
  
  f1.show();
  f5.show();
  f10.show();
  b1.show();
  b5.show();
  b10.show();
  r1.show();
  r15.show();
  r45.show();
  l1.show();
  l15.show();
  l45.show();
  scan.show();
  exec.show();
  vic.show();
  
  //draw pending command
  String move = "Move: "+ move_cmd +" cm";
  String turn = "Turn: " + turn_cmd + " degrees";
  
  fill(52);
  textFont(font);
  text(move, 340, window_size - 60); 
  text(turn, 340, window_size - 20); 
  
}


//create buttons
public void create_buttons(){
  
  
  float row1 = window_size - 40;
  float row2 = window_size - 60;
  float row3 = window_size - 80;
  float w = 48;
  float h = 30;
  

  int clr1 = color(240,108,132);
  
  b10 = new Button(10,row3,w,h,"  -10",clr1);
  b5 = new Button(65,row3,w,h,"   -5",clr1);
  b1 = new Button(120,row3,w,h,"   -1",clr1);
  f1 = new Button(175,row3,w,h,"   +1",clr1);
  f5 = new Button(230,row3,w,h,"   +5",clr1);
  f10 = new Button(285,row3,w,h,"  +10",clr1);
  
  l45 = new Button(10,row1,w,h,"  -45",clr1);
  l15 = new Button(65,row1,w,h,"  -15",clr1);
  l1 = new Button(120,row1,w,h,"   -1",clr1);
  r1 = new Button(175,row1,w,h,"   +1",clr1);
  r15 = new Button(230,row1,w,h,"  +15",clr1);
  r45 = new Button(285,row1,w,h,"  +45",clr1);
  
  exec = new Button(470,row3,w+10,h," execute",color(121,219,147));
  scan = new Button(470,row1,w+10,h,"   scan", color(121,219,147));
  
  vic = new Button(600,row3,116,70,"         victory",color(18,252,237));
  
}


public void draw_popup(){
  
  fill(212);
  stroke(255,38,92);
  strokeWeight(4);
  rect(0,window_size/2 - 50,window_size - 1, 100);
  
  fill(52);
  textFont(font_big);
  text(popup_text, window_size/2 - 300, window_size/2); 
  
}


public void draw_trail(){
 for(int i = 0; i < trail.size() - 1; i++){
   Point p1 = world_to_screen(trail.get(i));
   Point p2 = world_to_screen(trail.get(i+1));
   
   stroke(120,245,124);
   strokeWeight(3);
   
   line(p1.x,p1.y,p2.x,p2.y);
 } 
 strokeWeight(1);
  
}


public void draw_path(){
  
  if(move_cmd != 0){
    Point p1;
    if(move_cmd > 0){  
      p1 = polar_to_robot(move_cmd,turn_cmd + (int)robot.heading);
    }
    else{
      p1 = polar_to_robot(move_cmd,turn_cmd + (int)robot.heading);
    }
    p1.x += robot.pos.x;
    p1.y += robot.pos.y;
    
    p1 = world_to_screen(p1);
    Point p2 = world_to_screen(robot.pos);
    
    stroke(240,108,132);
    strokeWeight(3);
    line(p1.x,p1.y,p2.x,p2.y);
    noFill();
    strokeWeight(1);
    ellipse(p1.x,p1.y,robot.size * pixels_per_cm,robot.size * pixels_per_cm);
  }
}
  
  

//convert a point from global frame to screen frame
public Point world_to_screen(Point world_pnt){
  
  //cm to pixel
  float x  = world_pnt.x * pixels_per_cm;
  float y = world_pnt.y * pixels_per_cm;
  
  //shift frame
  x += window_size/2.0f;
  y = window_size/2.0f - y;
  
  Point pix_pnt = new Point(x,y); 
  
  return pix_pnt;
  
}

//convert a point from screen frame to global frame
public Point screen_to_world(Point pix_pnt){
  
  //shift frame
  float x = pix_pnt.x - window_size/2.0f;
  float y = window_size/2.0f - pix_pnt.y;
  
  //pixels to cm
  x = x / pixels_per_cm;
  y = y / pixels_per_cm;
  
  Point world_pnt = new Point(x,y);
  
  return world_pnt;
}

public Point polar_to_robot(int distance, int heading){
  return new Point(distance * sin(heading * PI /180), distance * cos(heading * PI / 180));
}

  public void settings() {  size(800, 500, P2D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FinalProjectGUI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
