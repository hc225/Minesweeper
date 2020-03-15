import de.bezier.guido.*;
public final static int NUM_ROWS = 16;
public final static int NUM_COLS = 16;
public final static int NUM_MINES = 32;
private boolean isLost = false;
private boolean firstClick = false;
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
    	if(!mines.contains(buttons[r][c]) && !buttons[r][c].isClicked())
    		mines.add(buttons[r][c]);
	}
}
public void draw ()
{
    background(0);
    if(isLost == true)
    {
    	displayLosingMessage();
        showAllMines();
    	displayRestartMessage();
    }
    if(isLost == false && isWon() == true)
    {
        displayWinningMessage();
        displayRestartMessage();
    }
}
public boolean isWon()
{
	int count = 0;
    for(int r = 0; r < NUM_ROWS; r++)
    	for(int c = 0; c < NUM_COLS; c++)
    		if((mines.contains(buttons[r][c]) && buttons[r][c].isFlagged()) || buttons[r][c].isClicked())
    			count++;
    return count == NUM_ROWS*NUM_COLS;
}
public void displayLosingMessage()
{
	String message = "YOU LOSE";
	for(int i = 0; i < message.length(); i++)
	{
		buttons[7][i+4].setLabel(message.substring(i,i+1));
		buttons[7][i+4].resultLabel = true;
	}
}
public void displayWinningMessage()
{
	String message = "YOU WIN";
	for(int i = 0; i < message.length(); i++)
	{
		buttons[7][i+4].setLabel(message.substring(i,i+1)); 
		buttons[7][i+4].resultLabel = true;
	}
}
public void displayRestartMessage()
{
    String message = "CLICK TO RESTART";
    for(int i = 0; i < message.length(); i++) 
        if(i < 5)
        {
            buttons[10][i+5].setLabel(message.substring(i,i+1));
            buttons[10][i+5].restartLabel = true; 
        }
        else if(i >= 5 && i < 9)
        {
            buttons[11][i+1].setLabel(message.substring(i,i+1));
            buttons[11][i+1].restartLabel = true;
        }
        else  
        {
            buttons[12][i-5].setLabel(message.substring(i,i+1));
            buttons[12][i-5].restartLabel = true;   
        }     
}
public void showAllMines()
{
	for(int r = 0; r < NUM_ROWS; r++)
    	for(int c = 0; c < NUM_COLS; c++)
    		if(mines.contains(buttons[r][c]) && !buttons[r][c].isFlagged())
    			buttons[r][c].clicked = true;
}
public void newGame()
{
    isLost = false;
    firstClick = false;
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
        {
            if(mines.contains(buttons[r][c]))
                mines.remove(buttons[r][c]);
            buttons[r][c].clicked = false;
            buttons[r][c].flagged = false;
            buttons[r][c].restartLabel = false; 
            buttons[r][c].resultLabel = false; 
            buttons[r][c].myLabel = "";   
        }
    setMines();
}
public boolean isValid(int r, int c)
{
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
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
    private boolean resultLabel, restartLabel; //to set different style for messages
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
        if(isWon() || isLost)
            newGame();
        else if(!clicked && mouseButton == RIGHT)
        {
        	flagged = !flagged;   
        	if(!flagged)
        	  clicked = false;
        }
        else if(!flagged && mines.contains(this))
        	isLost = true;
        else if(!flagged && countMines(myRow,myCol) > 0){
        	clicked = true;
        	setLabel(countMines(myRow,myCol));
        }
        else 
        {
        	if(!flagged)
	        {
	        	clicked = true;
				for(int r = myRow-1; r < myRow+2; r++)
	    			for(int c = myCol-1; c < myCol+2; c++)
	    				if(isValid(r,c) && !buttons[r][c].clicked && !buttons[r][c].flagged)
	    						buttons[r][c].mousePressed();
	    	}
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
        textSize(12);
        if(resultLabel)
        {
        	fill(0,0,255);
        	textSize(24);
        }
        if(restartLabel)
        {
            fill(0,0,255);
            textSize(16);
        }
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
    public boolean isClicked()
    {
    	return clicked;
    }
}



