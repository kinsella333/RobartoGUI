import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MainView extends PApplet {


PGraphics page;
PFont font;

Button drink0, drink1, drink2, drink3, drink4, drink5;

public void setup() {
  
  page = createGraphics(1080,800);
  font = createFont("Segoe UI", 15);
 }

public void draw() {

  page.beginDraw();
  page.background(255);
  page.noFill();
  page.endDraw();

  image(page,0 ,0);

  drink0 = new Button(100,100,175,250,"Drink 0",color(120,137,245));
  drink0.show();

  drink1 = new Button(400,100,175,250,"Drink 1",color(120,137,245));
  drink1.show();

  drink2 = new Button(700,100,175,250,"Drink 2",color(120,137,245));
  drink2.show();

  drink3 = new Button(100,450,175,250,"Drink 3",color(120,137,245));
  drink3.show();

  drink4 = new Button(400,450,175,250,"Drink 4",color(120,137,245));
  drink4.show();

  drink5 = new Button(700,450,175,250,"Drink 5",color(120,137,245));
  drink5.show();

}

public void mouseClicked(){

  if(drink0.check_click()){
      print("Drink 0 Selected\n");
  }
  if(drink1.check_click()){
      print("Drink 1 Selected\n");
  }
  if(drink2.check_click()){
      print("Drink 2 Selected\n");
  }
  if(drink3.check_click()){
      print("Drink 3 Selected\n");
  }
  if(drink4.check_click()){
      print("Drink 4 Selected\n");
  }
  if(drink5.check_click()){
      print("Drink 5 Selected\n");
  }
}


class Button{
 float x,y,w,h;
 String text;
 int clr;
 Button(float x, float y, float w, float h, String text,int clr){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.clr = clr;

 }

 public void show(){
    //rectMode(CENTER);
    fill(clr);
    noStroke();

    rect(x,y,w,h,7);

    fill(255);
    textFont(font);
    //textAlign(LEFT, BASELINE);
    text(text,x ,y + h*2/3.0f );

 }

 public boolean check_click(){
   return (mouseX > (x) && mouseX < (x + w) && mouseY > (y) && mouseY < (y +h));
 }

}
  public void settings() {  size(1000, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MainView" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
