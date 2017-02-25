//methods used to create UI



void draw_obstacles(){
  for(int i = 0; i < obstacles.size(); i++){
    obstacles.get(i).show();
    obstacles.get(i).check_HoverOver();
  }
}


//draw grid on map
void draw_grid(int spacing){
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
void draw_status(){
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

void draw_buttons(){
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
void create_buttons(){
  
  
  float row1 = window_size - 40;
  float row2 = window_size - 60;
  float row3 = window_size - 80;
  float w = 48;
  float h = 30;
  

  color clr1 = color(240,108,132);
  
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


void draw_popup(){
  
  fill(212);
  stroke(255,38,92);
  strokeWeight(4);
  rect(0,window_size/2 - 50,window_size - 1, 100);
  
  fill(52);
  textFont(font_big);
  text(popup_text, window_size/2 - 300, window_size/2); 
  
}


void draw_trail(){
 for(int i = 0; i < trail.size() - 1; i++){
   Point p1 = world_to_screen(trail.get(i));
   Point p2 = world_to_screen(trail.get(i+1));
   
   stroke(120,245,124);
   strokeWeight(3);
   
   line(p1.x,p1.y,p2.x,p2.y);
 } 
 strokeWeight(1);
  
}


void draw_path(){
  
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
Point world_to_screen(Point world_pnt){
  
  //cm to pixel
  float x  = world_pnt.x * pixels_per_cm;
  float y = world_pnt.y * pixels_per_cm;
  
  //shift frame
  x += window_size/2.0;
  y = window_size/2.0 - y;
  
  Point pix_pnt = new Point(x,y); 
  
  return pix_pnt;
  
}

//convert a point from screen frame to global frame
Point screen_to_world(Point pix_pnt){
  
  //shift frame
  float x = pix_pnt.x - window_size/2.0;
  float y = window_size/2.0 - pix_pnt.y;
  
  //pixels to cm
  x = x / pixels_per_cm;
  y = y / pixels_per_cm;
  
  Point world_pnt = new Point(x,y);
  
  return world_pnt;
}

Point polar_to_robot(int distance, int heading){
  return new Point(distance * sin(heading * PI /180), distance * cos(heading * PI / 180));
}

