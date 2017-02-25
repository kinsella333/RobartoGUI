

class Button{
 float x,y,w,h;
 String text;
 color clr;
 Button(float x, float y, float w, float h, String text,color clr){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.clr = clr;

 }

 void show(){
    //rectMode(CENTER);
    fill(clr);
    noStroke();

    rect(x,y,w,h,7);

    fill(255);
    textFont(font);
    //textAlign(LEFT, BASELINE);
    text(text,x ,y + h*2/3.0 );

 }

 boolean check_click(){
   return (mouseX > (x) && mouseX < (x + w) && mouseY > (y) && mouseY < (y +h));
 }

}
