import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 60;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
         buttons[r][c] = new MSButton(r, c);
      }
    }
    for(int m = 0; m < NUM_MINES; m++){
      setMines();
    }
}
public void setMines()
{
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if(mines.contains(buttons[r][c]) == false){
      mines.add(buttons[r][c]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(!mines.contains(buttons[r][c]) && !buttons[r][c].clicked){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    String lose = "you lost •^•";
    for(int c = 0; c < lose.length(); c++){
      buttons[0][c].setLabel(lose.substring(c, c + 1));
      }
     for (int i=0; i < mines.size(); i++){
      if (mines.get(i).flagged){
        mines.get(i).flagged = false;
      }
      mines.get(i).clicked = true;
    } 
     //for(int r = 0; r < NUM_ROWS; r++){
     // for(int c = 0; c < NUM_COLS; c++){
        //if(mines.contains(buttons[r][c])){
          //buttons[r][c].clicked = true;
            //fill(255, 0, 0);
       // }
  //    }
  //  }
      
}
public void displayWinningMessage()
{
    String win = "you won ☺!";
    for(int c = 0; c < win.length(); c++){
       buttons[0][c].setLabel(win.substring(c, c + 1));
    }
}
public boolean isValid(int r, int c)
{
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row - 1; r <= row + 1; r++){
      for(int c = col - 1; c <= col + 1; c++){
        if(isValid(r, c) == true){
          if(mines.contains(buttons[r][c])){
            if(!(r == row && c == col)){
              numMines++;
            }
          }
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true){
            flagged = clicked = false;
          }
          if(flagged == false){
            flagged = true;
          }
        }
          else if(mines.contains(this)){
            displayLosingMessage();
          }
          else if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
          }
          else{
            for(int r = myRow - 1; r <= myRow + 1; r++){
              for(int c = myCol - 1; c <= myCol + 1; c++){
                if(isValid(r, c) == true)
                  if(buttons[r][c].clicked == false)
                    buttons[r][c].mousePressed();
              }
            }
          }
        }
    public void draw ()
    {    
        if (flagged)
            fill(#EE9FDF);
        else if( clicked && mines.contains(this))
            fill(#F88467);
        else if(clicked)
            fill(#B7F4E2);   
        else
            fill(#80B7E1);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
