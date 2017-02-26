import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gifAnimation.*; 
import processing.serial.*; 

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
Gif loadingGIF;
Serial port;

Button b0, b1, b2, b3, b4, b5, backB, makeB;
Drink drink0, drink1, drink2, drink3, drink4, drink5;
Drink choice;
boolean drinkMenu = false, loadScreen = false, connected = false;
int x = 1200, count = 0, temp = 0;
int basicBC = color(255,255,255,175), menuBC = color(50,120,255,255);
long last_heartbeat = 0;

static final String bottle0 = "Rum", bottle1 = "Gin", bottle2 = "Whiskey", bottle3 = "Coke", bottle4 = "Tonic";

static final int CMD_HEARTBEAT = 0x40, CMD_HOME = 0x41, CMD_STOP = 0x42, CMD_MANUAL = 0x43, CMD_RECIPE = 0x44, CMD_COMPLETE = 0x45;

public void setup() {
  
  background = loadImage("assets/blur2.png");
  font = createFont("Segoe UI", 15);
  loadingGIF = new Gif(this, "assets/loading.gif");
  loadingGIF.play();
  frameRate(60);
  textAlign(CENTER);
  imageMode(CENTER);

  port = new Serial(this, "COM3", 115200);

  drink0 = new Drink("assets/G&T.png",100,100,175,250, "assets/G&T.txt", basicBC);
  drink1 = new Drink("assets/collegeLongIsland.png",400,100,175,250, "assets/collegeLongIsland.txt", basicBC);
  drink2 = new Drink("assets/jackNcoke.png",700,100,175,250, "assets/jackNcoke.txt", basicBC);
  drink3 = new Drink("assets/whiskeyStraight.png",100,450,175,250, "assets/whiskey.txt", basicBC);
  drink4 = new Drink("assets/cup1.png",400,450,175,250, "assets/G&T.txt", basicBC);
  drink5 = new Drink("assets/cup1.png",700,450,175,250, "assets/G&T.txt", basicBC);
 }

public void draw() {

  init();

  if(drinkMenu){
    drawDrinkMenu(choice);
  }
  if(loadScreen && x < -1000){
    drawLoadScreen();
  }

  if(port.available() > 0){
    char c = port.readChar();

    switch(c){
      case CMD_HEARTBEAT:
      last_heartbeat = millis();
      break;

      case CMD_COMPLETE:
      loadScreen = false;
      drinkMenu = false;
      x = 1200;
      count = 0;
      temp = 0;
      break;

      default:
      break;
    }
  }
  if(millis() - last_heartbeat > 1500){
      connected = false;
      //print("Connection lost\n");
  }else{
    connected = true;
  }

}

public void mouseClicked(){

  if(b0.check_click() && !drinkMenu && !loadScreen){
      print("Drink 0 Selected\n");
      drinkMenu= true;
      choice = drink0;
  }
  if(b1.check_click() && !drinkMenu && !loadScreen){
      print("Drink 1 Selected\n");
      drinkMenu= true;
      choice = drink1;
  }
  if(b2.check_click() && !drinkMenu && !loadScreen){
      print("Drink 2 Selected\n");
      drinkMenu= true;
      choice = drink2;
  }
  if(b3.check_click() && !drinkMenu && !loadScreen){
      print("Drink 3 Selected\n");
      drinkMenu= true;
      choice = drink3;
  }
  if(b4.check_click() && !drinkMenu && !loadScreen){
      print("Drink 4 Selected\n");
      drinkMenu= true;
      choice = drink4;
  }
  if(b5.check_click() && !drinkMenu && !loadScreen){
      print("Drink 5 Selected\n");
      drinkMenu= true;
      choice = drink5;
  }
  if(backB.check_click()){
      print("Back B Selected\n");
      drinkMenu= false;
      x = 1200;
      count = 0;
  }
  if(makeB.check_click()){
      print("Make B Selected\n");
      count = 0;
      loadScreen = true;

      port.write(CMD_RECIPE);
      port.write(choice.bottleNum);
      for(int i = 0; i < choice.recipeOrder.length; i++){
        if(choice.recipeOrder[i] > 0){
          port.write(i);
          port.write(choice.recipeOrder[i]);
        }
      }
  }
}

public void drawDrinkMenu(Drink choice){
  if(count == 0){
    choiceImage = loadImage(choice.imgPath);
  }
  if(count < 23 && !loadScreen){
    x = x - 50;
    count++;
  }else if(count < 23 && loadScreen){
    x = x - 50;
    count++;
  }

  //Fade Out Screen
  fill(0,0,0,count*2);
  rect(0,0,1000,800);

  //Drink Background, and Drink
  fill(255,255,255,200);
  rect(x,100,400,610,7);
  image(choiceImage, x + 200, 300, 300, 350);

  //Drink Title
  fill(50);
  textFont(createFont("Segoe UI", 35));
  text(choice.name, x + 200 , 600);

  //Recipe Background
  fill(0,0,0,200);
  rect(x + 400,100, 500, 610, 7);

  //Recipe Ingredient List
  fill(255);
  textFont(createFont("Segoe UI", 25));
  text(choice.recipe, x + 650, 175);

  //Recipe Description
  textAlign(LEFT);
  fill(255);
  textFont(createFont("Segoe UI", 20));
  text(choice.description, x + 450, 250 + 40*choice.bottleNum);
  textAlign(CENTER);

  backB.setPosition(x + 430, 650);
  backB.show();

  makeB.setPosition(x + 770, 650);
  makeB.show();

}

public void init(){
  image(background,500 ,400);

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

  backB = new Button(x, 650, 100, 50, "Back", menuBC, createFont("Segoe UI", 15));
  makeB = new Button(x, 650, 100, 50, "Make", menuBC, createFont("Segoe UI", 15));

}

public void drawLoadScreen(){
  if(count < 50){
    count += 3;
  }
  fill(0,0,0,count*4);
  rect(0,0,1000,800);

  //Loading Message
  fill(255);
  textFont(createFont("Segoe UI", 65));
  text("Making Drink, Please Wait", 500, 250);

  image(loadingGIF,500,550);

}


class Button{
 float x,y,w,h;
 String txt;
 PImage img;
 PFont xfont;
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

 Button(float x, float y, float w, float h, String txt, int clr, PFont xfont){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.txt = txt;
    this.clr = clr;
    this.xfont = xfont;
 }

 public void show(){
    //rectMode(CENTER);
    fill(this.clr);
    noStroke();
    rect(x,y,w,h,7);
    if(img != null){
      image(img, x + w/2 , y+ h/2 - 20 ,7*w/8.0f,2*h/3.0f);
    }

    if(xfont == null){
      fill(50);
      textFont(font);
      text(txt, x + w/2 ,y + h*7/8.0f );
    }else{
      fill(255);
      textFont(xfont);
      text(txt, x + w/2 ,y + 5*h/8.0f );
    }

 }

 public boolean check_click(){
   return (mouseX > (x) && mouseX < (x + w) && mouseY > (y) && mouseY < (y +h));
 }

 public void setPosition(float x, float y){
   this.x = x;
   this.y = y;
 }

}

class Drink{
    PImage img;
    BufferedReader input;
    String name, imgPath, recipePath, recipe, description = "";
    float x,y,w,h;
    int bottleNum;
    int clr;
    int[] recipeOrder = new int[5];

    Drink(String imgPath, float x, float y, float w, float h, String recipePath, int clr){
      this.img = loadImage(imgPath);
      this.input = createReader(recipePath);
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.clr = clr;
      this.imgPath = imgPath;

      getRecipe();
    }

    public Button getButton(){
      return new Button(x, y, w, h, name, img, clr);
    }

    public void getRecipe(){
      String line, out = "                    Recipe                    \n";
      String[] sLine;
      String bChoice, tempLine = "";
      boolean recipeRead = false, temp = false;
      int choiceN = -1, length = 0, j = 0;

      try{
        this.name = input.readLine();
        while((line = input.readLine()) != null){

            if(line.contains("Description:")){
              recipeRead = true;
              this.description += "Description:\n";
              continue;
            }

            if(recipeRead){
              this.description += line + "\n";

            }else if((sLine = split(line, " ")).length > 0){
              bChoice = sLine[0];

              switch(bChoice){
                case bottle0: recipeOrder[0] = recipeOrder[0] + PApplet.parseInt(sLine[2]);
                        out = out + bottle0;
                        length = bottle0.length();
                        choiceN= 0;
                        break;
                case bottle1: recipeOrder[1] = recipeOrder[1] + PApplet.parseInt(sLine[2]);
                        out = out + bottle1 + ":";
                        length = bottle1.length() - 1;
                        choiceN= 1;
                        break;
                case bottle2: recipeOrder[2] = recipeOrder[2] + PApplet.parseInt(sLine[2]);
                        out = out + bottle2  + ":";
                        length = bottle2.length() + 2;
                        choiceN= 2;
                        break;
                case bottle3: recipeOrder[3] = recipeOrder[3] + PApplet.parseInt(sLine[2]);
                        out = out + bottle3  + ":";
                        length = bottle3.length();
                        choiceN= 3;
                        break;
                case bottle4: recipeOrder[4] = recipeOrder[4] + PApplet.parseInt(sLine[2]);
                        out = out + bottle4 + ":";
                        length = bottle4.length();
                        choiceN= 4;
                        break;
                default:
                continue;
              }

              for(int i = 0; i < 40 - length; i++){
                out += " ";
              }
              out +=  recipeOrder[choiceN] + "oz\n";
              bottleNum++;
            }
        }
      }catch(Exception e){
        e.printStackTrace();
      }
      this.recipe = out;
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
