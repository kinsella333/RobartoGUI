
class Drink{
    PImage img;
    BufferedReader input;
    String name, imgPath, recipePath, recipe, description = "";
    float x,y,w,h;
    int bottleNum;
    color clr;
    int[] recipeOrder = new int[5];

    Drink(String imgPath, float x, float y, float w, float h, String recipePath, color clr){
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

    Button getButton(){
      return new Button(x, y, w, h, name, img, clr);
    }

    void getRecipe(){
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
                case bottle0: recipeOrder[0] = recipeOrder[0] + int(sLine[2]);
                        out = out + bottle0;
                        length = bottle0.length();
                        choiceN= 0;
                        break;
                case bottle1: recipeOrder[1] = recipeOrder[1] + int(sLine[2]);
                        out = out + bottle1 + ":";
                        length = bottle1.length() - 1;
                        choiceN= 1;
                        break;
                case bottle2: recipeOrder[2] = recipeOrder[2] + int(sLine[2]);
                        out = out + bottle2  + ":";
                        length = bottle2.length() + 2;
                        choiceN= 2;
                        break;
                case bottle3: recipeOrder[3] = recipeOrder[3] + int(sLine[2]);
                        out = out + bottle3  + ":";
                        length = bottle3.length();
                        choiceN= 3;
                        break;
                case bottle4: recipeOrder[4] = recipeOrder[4] + int(sLine[2]);
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
