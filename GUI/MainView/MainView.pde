
PGraphics page;
PFont font;

Button drink0, drink1, drink2, drink3, drink4, drink5;

void setup() {
  size(1000, 800);
  page = createGraphics(1080,800);
  font = createFont("Segoe UI", 15);
 }

void draw() {

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

void mouseClicked(){

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
