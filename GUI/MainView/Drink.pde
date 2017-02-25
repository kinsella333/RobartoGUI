
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

    Button getButton(){
      return new Button(x, y, w, h, name, img, clr);
    }

    String getRecipe(){
      String line, out = "               Recipe               \n";
      String[] sLine;
      int bChoice;

      try{
        while((line = input.readLine()) != null){
            sLine = split(line, " ");
            bChoice = int(sLine[1].substring(0,1));

            switch(bChoice){
              case 0: recipeOrder[0] = recipeOrder[0] + int(sLine[2]);
                      out = out + bottle0 + "                              " + recipeOrder[0] + "oz\n";
                      break;
              case 1: recipeOrder[1] = recipeOrder[1] + int(sLine[2]);
                      out = out + bottle1 + "                              " + recipeOrder[1] + "oz\n";
                      break;
              case 2: recipeOrder[2] = recipeOrder[2] + int(sLine[2]);
                      out = out + bottle2 + "                              " + recipeOrder[2] + "oz\n";
                      break;
              case 3: recipeOrder[3] = recipeOrder[3] + int(sLine[2]);
                      out = out + bottle3 + "                              " + recipeOrder[3] + "oz\n";
                      break;
              case 4: recipeOrder[4] = recipeOrder[4] + int(sLine[2]);
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
