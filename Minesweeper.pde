import de.bezier.guido.*;
private int NUM_ROWS = 5;
private int NUM_COLS = 5;
private int NUM_MINES = 2;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
    	for(int c = 0; c < NUM_COLS; c++)
    		buttons[r][c] = new MSButton(r,c);    
    setMines();
}
public void setMines()
{
	while(mines.size() < NUM_MINES)
	{
		int r = (int)(Math.random()*NUM_ROWS);
    	int c = (int)(Math.random()*NUM_COLS);
    	if(!mines.contains(buttons[r][c]))
    		mines.add(buttons[r][c]);
	}
}
public void draw ()
{
    background(0);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
	int flaggedMines = 0;
    for(int r = 0; r < NUM_ROWS; r++)
    	for(int c = 0; c < NUM_COLS; c++)
    		if(mines.contains(buttons[r][c]) && buttons[r][c].isFlagged() == true)
    			flaggedMines++;
    if(flaggedMines == NUM_MINES)
    	return true;
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) 
    	return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r < row+2; r++)
    	for(int c = col-1; c < col+2; c++)
    		if(isValid(r,c) && mines.contains(buttons[r][c]))
    			if(r == row && c != col || r != row)
    				numMines++;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton(int row, int col)
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
    public void mousePressed() 
    {
        clicked = true;
        if(mouseButton == RIGHT)
        {
        	flagged = !flagged;
        	if(flagged == false)
        	  clicked = false;
        }
        else if(mines.contain(this))
        	displayLosingMessage();
        else if(countMines(myRow,myCol) > 0)
        	setLabel(countMines(myRow,myCol));
        else 
        {
        	for(int r = myRow-1; r < myRow+2; r++)
    			for(int c = myCol-1; c < myCol+2; c++)
    				if(isValid(r,c) && flagged == false)
    					if(r == myRow && c != myCol || r != myRow)
    						button[r][c].mousePressed();
        }
    }
    public void draw() 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

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



