

///////////////////////////////////////////////////////////////////COMMANDS////////////////////////////////////////////////////////

void request_status() {
  byte msg;
  msg = 3; //type
  port.write(msg);
}

void request_last_message() {
  byte msg;
  msg = 4; //type
  port.write(msg);
}

void command_movement(int movement) {
  int speed = 200;


  byte[] msg = new byte[5];
  msg[0] = 0; //type
  msg[1] = byte((movement & 0xFF00) >> 8) ; //distance  0
  msg[2] = byte(movement & 0x00FF);    //10
  msg[3] = byte(speed >> 8); //speed of motors //0
  msg[4] = byte(speed & 0x00FF);  //200
  
  write_msg(msg,5);
}

void command_turn(int rotation) {

  int speed = 100;

  byte[] msg = new byte[5];
  msg[0] = 1; //type
  msg[1] = byte((rotation & 0xFF00) >> 8); //angle
  msg[2] = byte(rotation & 0xFF);
  msg[3] = byte(speed >> 8); //speed of motors
  msg[4] = byte(speed & 0x00FF);

   write_msg(msg,5);
}

void command_scan() {
  byte msg;
  msg = 2; //type
  port.write(msg);
}

void command_victory(){
    byte msg;
  msg = 5; //type
  port.write(msg);
  
  
}


///////////////////////////////////////////////////////////////MESSSAGES////////////////////////////////////////////////

void parse_bumper() {
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


void parse_status() {
  
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

void parse_scan() {
  
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
       obstacles.add(new Obstacle(loc, size * 1.0, 0));
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

void parse_cliff() {
  
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

void parse_wall() {
  
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


void parse_marker(){
  
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

int parse_int(char high, char low) {
  int c = (int)((high << 8) | low);
  if ((high & 0x80) >> 7 == 1) { //convert 2 byte int to 4 byte int
    c = c | (0xFFFF << 16);
  }
  return c;
}

void read_chars(char[] msg, int size) {
  int index = 0;
  while (index < size) {
      msg[index] = SerialBuffer.dekueue();
      index++;
  } 
}


void write_msg(byte[] msg, int size){
  for(int i = 0; i < 5; i++){
      port.write(msg[i]);
  }  
}

void port_flush(){
 while(port.available() > 0){
  port.readChar();
 } 
  
}

/////////////////////////////////////////////////////////////////////////////////////MESSAGE DISPATCH/////////////////////////////////////////////////
void parse_uart(){
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



void parseError(){
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


void start_parse(char type) {


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







