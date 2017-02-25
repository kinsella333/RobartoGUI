
import gifAnimation.*;

PFont font;
PImage background;
PImage choiceImage;
Gif loadingGIF;

Button b0, b1, b2, b3, b4, b5, backB, makeB;
Drink drink0, drink1, drink2, drink3, drink4, drink5;
Drink choice;
boolean drinkMenu = false, loadScreen = false;
int x = 1200, count = 0, temp = 0;
color basicBC = color(255,255,255,175), menuBC = color(50,120,255,255);

static final String bottle0 = "Rum", bottle1 = "Gin", bottle2 = "Whiskey", bottle3 = "Coke", bottle4 = "Tonic";

static final int CMD_HEARTBEAT = #40, CMD_HOME = #41, CMD_STOP = #42, CMD_MANUAL = #43, CMD_RECIPE = #44

void setup() {
  size(1000, 800);
  background = loadImage("assets/blur2.png");
  font = createFont("Segoe UI", 15);
  loadingGIF = new Gif(this, "assets/loading.gif");
  loadingGIF.play();
  frameRate(60);
  textAlign(CENTER);
  imageMode(CENTER);

  drink0 = new Drink("assets/cup1.png",100,100,175,250, "assets/G&T.txt", basicBC);
  drink1 = new Drink("assets/cup1.png",400,100,175,250, "assets/awfulDrink.txt", basicBC);
  drink2 = new Drink("assets/cup1.png",700,100,175,250, "assets/G&T.txt", basicBC);
  drink3 = new Drink("assets/cup1.png",100,450,175,250, "assets/G&T.txt", basicBC);
  drink4 = new Drink("assets/cup1.png",400,450,175,250, "assets/G&T.txt", basicBC);
  drink5 = new Drink("assets/cup1.png",700,450,175,250, "assets/G&T.txt", basicBC);
 }

void draw() {

  init();

  if(drinkMenu){
    drawDrinkMenu(choice);
  }
  if(loadScreen && x < -1000){
    drawLoadScreen();
    temp++;
  }
  if(temp > 500){
    loadScreen = false;
    drinkMenu = false;
    x = 1200;
    count = 0;
    temp = 0;
  }

}

void mouseClicked(){

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

      //port.write(COMMAND_RECIPE);

      //port.write(choice.bottleNum);
      for(int i = 0; i < choice.recipeOrder.length; i++){
        if(choice.recipeOrder[i] > 0){
          //port.write(i);
          //port.write(choice.recipeOrder[i]);
        }
      }
  }
}

void drawDrinkMenu(Drink choice){
  if(count == 0){
    choiceImage = loadImage(choice.imgPath);
    choiceImage.resize(250,300);
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
  image(choiceImage, x + 200, 300);

  //Drink Title
  fill(0);
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
  fill(255);
  textFont(createFont("Segoe UI", 20));
  text(choice.description, x + 650, 250 + 40*choice.bottleNum);

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

  backB = new Button(x, 650, 100, 50, "Back", menuBC, createFont("Segoe UI", 15));
  makeB = new Button(x, 650, 100, 50, "Make", menuBC, createFont("Segoe UI", 15));

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
