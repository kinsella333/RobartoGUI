/**
 *CPRE 288 final project
 *GUI for visually the robots position
 */


import processing.serial.*;


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
float pixels_per_cm = window_size * 1.0 / world_size;

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
Button;, f5, f10, b1, b5, b10, r1, r15, r45, r90, l1, l15, l45, l90, resend, req_stat, scan, exec, vic;

Serial port;
Kueue SerialBuffer;



void setup() {

  //create window
  size(800, 500, P2D);
  smooth();

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

void draw() {
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
  pixels_per_cm = window_size * 1.0 / world_size;

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




void mouseClicked() {

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






void keyPressed() {
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


void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  world_size = max(world_size + (int)(50 * e), 300);
  world_size = min(world_size + (int)(50 * e), 4500);
}
