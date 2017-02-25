

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

 void show(){
    //rectMode(CENTER);
    fill(255,255,255,clr);
    //noStroke();
    rect(x,y,w,h,7);
    image(img, x + w/4 , y+ h/8 ,w/2,h/2);

    fill(0);
    textFont(font);
    //textAlign(LEFT, BASELINE);
    text(txt, x + w/3 ,y + h*7/8.0 );
 }

 boolean check_click(){
   return (mouseX > (x) && mouseX < (x + w) && mouseY > (y) && mouseY < (y +h));
 }

}
