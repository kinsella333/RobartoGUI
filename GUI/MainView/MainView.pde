
import gifAnimation.*;
import processing.serial.*;

PFont font;
PImage background;
PImage choiceImage;
Gif loadingGIF;
Serial port;

Button b0, b1, b2, b3, b4, b5, backB, makeB, rumB, ginB, whiskeyB, cokeB, tonicB, exitBYO, plus, minus, make2;
Drink drink0, drink1, drink2, drink3, drink4, drink5;
Drink choice;
boolean drinkMenu = false, loadScreen = false, connected = false, byoMenu = false;
int x = 1200, count = 0, temp = 0;
color basicBC = color(255,255,255,175), menuBC = color(50,120,255,255), selectedC = color(200,100,150,255);
long last_heartbeat = 0;
String selectedBooze;

static final String bottle0 = "Rum", bottle1 = "Gin", bottle2 = "Whiskey", bottle3 = "Coke", bottle4 = "Tonic";

static final int CMD_HEARTBEAT = 0x40, CMD_HOME = 0x41, CMD_STOP = 0x42, CMD_MANUAL = 0x43, CMD_RECIPE = 0x44, CMD_COMPLETE = 0x45;

void setup() {
  size(1000, 800);
  background = loadImage("assets/blur2.png");
  font = createFont("Segoe UI", 15);
  loadingGIF = new Gif(this, "assets/loading.gif");
  loadingGIF.play();
  frameRate(60);
  textAlign(CENTER);
  imageMode(CENTER);

  //port = new Serial(this, "COM3", 115200);

  drink0 = new Drink("assets/G&T.png",100,100,175,250, "assets/G&T.txt", basicBC);
  drink1 = new Drink("assets/collegeLongIsland.png",400,100,175,250, "assets/collegeLongIsland.txt", basicBC);
  drink2 = new Drink("assets/jackNcoke.png",700,100,175,250, "assets/jackNcoke.txt", basicBC);
  drink3 = new Drink("assets/whiskeyStraight.png",100,450,175,250, "assets/whiskey.txt", basicBC);
  drink4 = new Drink("assets/virgin.png",400,450,175,250, "assets/virgin.txt", basicBC);
  drink5 = new Drink("assets/buildYourOwn.png",700,450,175,250, "assets/buildYourOwn.txt", basicBC);

  backB = new Button(x, 650, 100, 50, "Back", menuBC, createFont("Segoe UI", 15));
  makeB = new Button(x, 650, 100, 50, "Make", menuBC, createFont("Segoe UI", 15));

  rumB = new Button(x, 100, 100, 50, "Rum", menuBC, createFont("Segoe UI", 15));
  ginB = new Button(x, 200, 100, 50, "Gin", menuBC, createFont("Segoe UI", 15));
  whiskeyB = new Button(x, 300, 100, 50, "Whiskey", menuBC, createFont("Segoe UI", 15));
  cokeB = new Button(x, 400, 100, 50, "Coke", menuBC, createFont("Segoe UI", 15));
  tonicB = new Button(x, 500, 100, 50, "Tonic", menuBC, createFont("Segoe UI", 15));
  exitBYO = new Button(x, 600, 100, 50, "Back", menuBC, createFont("Segoe UI", 15));
  plus = new Button(x + 100, 200, 100, 200, "+", menuBC, createFont("Segoe UI", 15));
  minus = new Button(x + 100, 400, 100, 200, "-", menuBC, createFont("Segoe UI", 15));
  make2 = new Button(x, 650, 100, 50, "Make", menuBC, createFont("Segoe UI", 15));
 }

void draw() {

  init();

  if(drinkMenu){
    drawDrinkMenu(choice);
  }
  if(loadScreen && x < -1000){
    drawLoadScreen();
  }
  if(byoMenu){
    drawBYO();
  }
/*
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
*/
}

void mouseClicked(){

  //Main Menu Buttons
  if(b0.check_click() && !drinkMenu && !loadScreen && !byoMenu){
      drinkMenu= true;
      choice = drink0;
  }
  if(b1.check_click() && !drinkMenu && !loadScreen && !byoMenu){
      drinkMenu= true;
      choice = drink1;
  }
  if(b2.check_click() && !drinkMenu && !loadScreen && !byoMenu){
      drinkMenu= true;
      choice = drink2;
  }
  if(b3.check_click() && !drinkMenu && !loadScreen && !byoMenu){
      drinkMenu= true;
      choice = drink3;
  }
  if(b4.check_click() && !drinkMenu && !loadScreen && !byoMenu){
      drinkMenu= true;
      choice = drink4;
  }
  if(b5.check_click() && !drinkMenu && !loadScreen && !byoMenu){
      byoMenu= true;
      choice = drink5;
  }

  //Drink Menu Buttons
  if(backB.check_click()){
      drinkMenu= false;
      x = 1200;
      count = 0;
  }
  if(makeB.check_click()){
      count = 0;
      loadScreen = true;

      /*port.write(CMD_RECIPE);
      port.write(choice.bottleNum);
      for(int i = 0; i < choice.recipeOrder.length; i++){
        if(choice.recipeOrder[i] > 0){
          port.write(i);
          port.write(choice.recipeOrder[i]);
        }
      }*/
  }

  //BYO Menu Buttons
  if(rumB.check_click()){
    rumB.setColor(selectedC);
    ginB.setColor(menuBC);
    whiskeyB.setColor(menuBC);
    cokeB.setColor(menuBC);
    tonicB.setColor(menuBC);

    selectedBooze = bottle0;
  }
  if(ginB.check_click()){
    rumB.setColor(menuBC);
    ginB.setColor(selectedC);
    whiskeyB.setColor(menuBC);
    cokeB.setColor(menuBC);
    tonicB.setColor(menuBC);

    selectedBooze = bottle1;
  }
  if(whiskeyB.check_click()){
    rumB.setColor(menuBC);
    ginB.setColor(menuBC);
    whiskeyB.setColor(selectedC);
    cokeB.setColor(menuBC);
    tonicB.setColor(menuBC);

    selectedBooze = bottle2;
  }
  if(cokeB.check_click()){
    rumB.setColor(menuBC);
    ginB.setColor(menuBC);
    whiskeyB.setColor(menuBC);
    cokeB.setColor(selectedC);
    tonicB.setColor(menuBC);

    selectedBooze = bottle3;
  }
  if(tonicB.check_click()){
    rumB.setColor(menuBC);
    ginB.setColor(menuBC);
    whiskeyB.setColor(menuBC);
    cokeB.setColor(menuBC);
    tonicB.setColor(selectedC);

    selectedBooze = bottle4;
  }
  if(exitBYO.check_click()){
    byoMenu = false;
    x = 1200;
    count = 0;
  }
  if(plus.check_click()){
    switch(selectedBooze){
      case bottle0:
              if(drink5.getTotalOz() < 8){
                drink5.recipeOrder[0]++;
              }
              break;
      case bottle1:
              if(drink5.getTotalOz() < 8){
                drink5.recipeOrder[1]++;
              }
              break;
      case bottle2:
              if(drink5.getTotalOz() < 8){
                drink5.recipeOrder[2]++;
              }
              break;
      case bottle3:
              if(drink5.getTotalOz() < 8){
                drink5.recipeOrder[3]++;
              }
              break;
      case bottle4:
              if(drink5.getTotalOz() < 8){
                drink5.recipeOrder[4]++;
              }
              break;
      default:
      break;
    }
  }
  if(minus.check_click()){
    switch(selectedBooze){
      case bottle0:
              if(drink5.recipeOrder[0] > 0){
                drink5.recipeOrder[0]--;
              }
              break;
      case bottle1:
              if(drink5.recipeOrder[0] > 0){
                drink5.recipeOrder[1]--;
              }
              break;
      case bottle2:
              if(drink5.recipeOrder[0] > 0){
                drink5.recipeOrder[2]--;
              }
              break;
      case bottle3:
              if(drink5.recipeOrder[0] > 0){
                drink5.recipeOrder[3]--;
              }
              break;
      case bottle4:
              if(drink5.recipeOrder[0] > 0){
                drink5.recipeOrder[4]--;
              }
              break;
      default:
      break;
    }
    drink5.totaloz--;
  }
  if(make2.check_click()){
    count = 0;
    loadScreen = true;
    choice = drink5;

    /*port.write(CMD_RECIPE);
    port.write(choice.bottleNum);
    for(int i = 0; i < choice.recipeOrder.length; i++){
      if(choice.recipeOrder[i] > 0){
        port.write(i);
        port.write(choice.recipeOrder[i]);
      }
    }*/
  }
}

void drawDrinkMenu(Drink choice){
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
  fill(0,0,0,215);
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

void init(){
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

}

void drawLoadScreen(){
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

void drawBYO(){
  if(count < 23 && !loadScreen){
    x = x - 50;
    count++;
  }else if(count < 23 && loadScreen){
    x = x - 50;
    count++;
  }

  //Fade Out Screen
  fill(0,0,0,count*4 + 100);
  rect(0,0,1000,800);

  rumB.setPosition(x, 100);
  ginB.setPosition(x, 200);
  whiskeyB.setPosition(x, 300);
  cokeB.setPosition(x, 400);
  tonicB.setPosition(x, 500);
  exitBYO.setPosition(x, 600);
  plus.setPosition(x + 200, 150);
  minus.setPosition(x + 200, 450);
  make2.setPosition(x + 700, 600);


  rumB.show();
  whiskeyB.show();
  cokeB.show();
  ginB.show();
  tonicB.show();
  exitBYO.show();
  plus.show();
  minus.show();
  make2.show();

  //Recipe Background
  fill(255,255,255,215);
  rect(x + 400,100, 500, 400, 7);

  textAlign(LEFT);
  //Recipe Ingredient List
  fill(0);
  textFont(createFont("Segoe UI", 25));
  text("              Recipe                    \nRum:                    " + drink5.recipeOrder[0] +
  "oz\nGin:                      " + drink5.recipeOrder[1] + "oz\nWhiskey:              " + drink5.recipeOrder[2] +
  "oz\nCoke                    " + drink5.recipeOrder[3] + "oz\nTonic:                   " + drink5.recipeOrder[4] +
  "oz\n               Total oz: " + drink5.getTotalOz() + "(8)", x + 535, 175);
  textAlign(CENTER);

}
