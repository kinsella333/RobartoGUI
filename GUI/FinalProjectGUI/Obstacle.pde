class Obstacle{
  
  
  float diameter; //cm
  Point pos; //cm
  color clr;
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
  
  boolean check_HoverOver(){
    
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
  
  void show(){
    float pix_diameter = diameter * pixels_per_cm;
    Point screen = world_to_screen(pos);
    
    shapeMode(CENTER);
    fill(clr);
    stroke(clr);
    ellipse(screen.x,screen.y,pix_diameter,pix_diameter);
  }
  
}
