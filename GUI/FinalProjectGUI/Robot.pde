
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
    
    void set_all(Point pos, float heading){
      set_position(pos);
      set_heading(heading);
    }
    
    void set_position(Point pos){
      this.pos = pos;
      
    }
    
    void set_heading(float heading){
     
      this.heading = heading;
      
    }
    
    void set_status(String status){
     this.status = status; 
      
    }
    
    void show(){

      //create robot shape
      PShape robot = createShape(GROUP);
  
      float pix_diameter = (size * pixels_per_cm);
      
      shapeMode(CENTER);
      fill(0);
      PShape circle = createShape(ELLIPSE, 0, 0, pix_diameter, pix_diameter);
      circle.setFill(color(0));
      circle.setStroke(color(0));
      
      PShape arc = createShape(ARC, 0, 0, pix_diameter, pix_diameter, 0 -.4, PI + .4,OPEN);
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
