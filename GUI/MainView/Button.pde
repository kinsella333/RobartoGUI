

class Button{
 float x,y,w,h;
 String txt;
 PImage img;
 PFont xfont;
 color clr;

 Button(float x, float y, float w, float h, String txt, PImage img, color clr){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
    this.txt = txt;
    this.clr = clr;
 }

 Button(float x, float y, float w, float h, String txt, color clr, PFont xfont){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.txt = txt;
    this.clr = clr;
    this.xfont = xfont;
 }

 void show(){
    //rectMode(CENTER);
    fill(this.clr);
    noStroke();
    rect(x,y,w,h,7);
    if(img != null){
      image(img, x + w/2 , y+ h/2 ,w/2,h/2);
    }

    if(xfont == null){
      fill(0);
      textFont(font);
    //  textAlign(CENTER);
      text(txt, x + w/2 ,y + h*7/8.0 );
    }else{
      fill(255);
      textFont(xfont);
      text(txt, x + w/2 ,y + 5*h/8.0 );
    }

 }

 boolean check_click(){
   return (mouseX > (x) && mouseX < (x + w) && mouseY > (y) && mouseY < (y +h));
 }

 void setPosition(float x, float y){
   this.x = x;
   this.y = y;
 }

}
