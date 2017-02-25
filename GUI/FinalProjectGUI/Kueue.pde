

class Kueue{
 ArrayList<Char> list;
  
 Kueue(){
    list = new ArrayList<Char>();
 } 
  
 char dekueue(){
    char c = list.get(0).get();
    for(int i = 0; i < list.size() - 1; i++){
       list.set(i,list.get(i+1));
    }
    list.remove(list.size() -1);
    return c;
 }  
  
  
 void enkueue(char c){
    list.add(new Char(c));
 }
 
 int size(){
     return list.size(); 
   
 }
 
 void clear(){
  for(int i = 0; i < list.size(); i++){
     list.remove(i);
  } 
 }
 
 void prnt(){
   for(int i = 0; i < list.size(); i++){
      print((int) list.get(i).get());
      print(" ,");
  }
   println();
 }
   
  
}
