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


PFont font;
PImage background;
PImage choiceImage;

Button b0, b1, b2, b3, b4, b5, bMenu;
Drink drink0, drink1, drink2, drink3, drink4, drink5, drinkMenu;
Drink choice;
boolean selection = false;
int x = 1200, count = 0;

String bottle0 = "Rum:    ", bottle1 = "Gin:     ", bottle2 = "Whiskey:", bottle3 = "Coke:   ", bottle4 = "Tonic:  ";

public void setup() {
  
  background = loadImage("include/blur2.png");
  font = createFont("Segoe UI", 15);
  frameRate(60);

  drink0 = new Drink("Drink 0","include/cup1.png",100,100,175,250, "include/G&T.txt", 100);
  drink1 = new Drink("Drink 1","include/cup1.png",400,100,175,250, "include/G&T.txt", 100);
  drink2 = new Drink("Drink 2","include/cup1.png",700,100,175,250, "include/G&T.txt", 100);
  drink3 = new Drink("Drink 3","include/cup1.png",100,450,175,250, "include/G&T.txt", 100);
  drink4 = new Drink("Drink 4","include/cup1.png",400,450,175,250, "include/G&T.txt", 100);
  drink5 = new Drink("Drink 5","include/cup1.png",700,450,175,250, "include/G&T.txt", 100);
 }

public void draw() {

  image(background,0 ,0);

  b0 = drink0.getButton();
  b0.show();

  b1 = drink1.getButton();
  b1.show();

  b2 = drink2.getButton();
  b2.show();

  b3 = drink3.getButton();
  b3.show();

  b4 = drink4.getButton();
  b4.show();

  b5 = drink5.getButton();
  b5.show();

  if(selection){
    drinkMenu(choice);
  }else{
    selection = false;
  }


}

public void mouseClicked(){

  if(b0.check_click()){
      print("Drink 0 Selected\n");
      selection = true;
      choice = drink0;
  }
  if(b1.check_click()){
      print("Drink 1 Selected\n");
      selection = true;
      choice = drink1;
  }
  if(b2.check_click()){
      print("Drink 2 Selected\n");
      selection = true;
      choice = drink2;
  }
  if(b3.check_click()){
      print("Drink 3 Selected\n");
      selection = true;
      choice = drink3;
  }
  if(b4.check_click()){
      print("Drink 4 Selected\n");
      selection = true;
      choice = drink4;
  }
  if(b5.check_click()){
      print("Drink 5 Selected\n");
      selection = true;
      choice = drink5;
  }
}

public void drinkMenu(Drink choice){
  if(count == 0){
    choiceImage = loadImage(choice.imgPath);
    choiceImage.resize(250,300);
  }
  if(count < 77){
    x = x - 15;
    count++;
  }

  fill(0,0,0,count*2);
  rect(0,0,1000,800);

  fill(255,255,255);
  rect(x,100,400,610,7);
  image(choiceImage, x + 80, 150);

  fill(0);
  textFont(createFont("Segoe UI", 35));
  text(choice.name, x + 140 , 600);

  fill(0,0,0,150);
  rect(x + 400,100, 500, 610, 7);

  fill(255);
  textFont(createFont("Segoe UI", 25));
  text(choice.recipe, x + 450 , 175);

}


class Button{
 float x,y,w,h;
 String txt;
 PImage img;
 int clr;

 Button(float x, float y, float w, float h, String txt, PImage img, int clr){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
    this.txt = txt;
    this.clr = clr;
 }

 public void show(){
    //rectMode(CENTER);
    fill(255,255,255,clr);
    //noStroke();
    rect(x,y,w,h,7);
    image(img, x + w/4 , y+ h/8 ,w/2,h/2);

    fill(0);
    textFont(font);
    //textAlign(LEFT, BASELINE);
    text(txt, x + w/3 ,y + h*7/8.0f );
 }

 public boolean check_click(){
   return (mouseX > (x) && mouseX < (x + w) && mouseY > (y) && mouseY < (y +h));
 }

}

class Drink{
    PImage img;
    BufferedReader input;
    String name, imgPath, recipePath, recipe;
    float x,y,w,h;
    int clr;
    int[] recipeOrder = new int[5];

    Drink(String name, String imgPath, float x, float y, float w, float h, String recipePath, int clr){
      this.name = name;
      this.img = loadImage(imgPath);
      this.input = createReader(recipePath);
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.clr = clr;
      this.imgPath = imgPath;

      this.recipe = getRecipe();
    }

    public Button getButton(){
      return new Button(x, y, w, h, name, img, clr);
    }

    public String getRecipe(){
      String line, out = "               Recipe               \n";
      String[] sLine;
      int bChoice;

      try{
        while((line = input.readLine()) != null){
            sLine = split(line, " ");
            bChoice = PApplet.parseInt(sLine[1].substring(0,1));

            switch(bChoice){
              case 0: recipeOrder[0] = recipeOrder[0] + PApplet.parseInt(sLine[2]);
                      out = out + bottle0 + "                              " + recipeOrder[0] + "oz\n";
                      break;
              case 1: recipeOrder[1] = recipeOrder[1] + PApplet.parseInt(sLine[2]);
                      out = out + bottle1 + "                              " + recipeOrder[1] + "oz\n";
                      break;
              case 2: recipeOrder[2] = recipeOrder[2] + PApplet.parseInt(sLine[2]);
                      out = out + bottle2 + "                              " + recipeOrder[2] + "oz\n";
                      break;
              case 3: recipeOrder[3] = recipeOrder[3] + PApplet.parseInt(sLine[2]);
                      out = out + bottle3 + "                              " + recipeOrder[3] + "oz\n";
                      break;
              case 4: recipeOrder[4] = recipeOrder[4] + PApplet.parseInt(sLine[2]);
                      out = out + bottle4 + "                              " + recipeOrder[4] + "oz\n";
                      break;
              default:
                print("Error on Parse on Recipe File");
                break;
            }
        }
      }catch(Exception e){
        e.printStackTrace();
      }
      return out;
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
