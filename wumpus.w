@* Hunt the Wumpus. This is a Literate-java implementation of Hunt the wumpus game, 
which interacts with the user through command line tools. 

This code is comprised of several main sections that determine the behavior of 
the user({\bf hunter}) and the wumpus({\bf wumpus}). Main sections of the game are 
1. {\bf init}, 2. taking {\bf userinput}, 3. {\bf move} player and wumpus, 4. {\bf shoot}, 
and 5. {\bf gameover}, which determines the result of the game. 

Variables used in this implementation of the game are:
{\bf cave[][]}: list of the cave where the user and wumpus can enter
{\bf bat1, bat2, pit1, pit2}: types of hazard
{\bf hunter, arrow, arrwnum}: user's position, final position of the arrow that the user shoot,
and the number of arrows the hunter has at the moment
{\bf wumpus}: position of Wumpus
{\bf seed, oldsd}: seed for random number generator
{\bf gameon, win, same}: represents different status of the game. {\bf same} is used when 
the user wants to play the game again with the same plot 
{\bf ran}: random number generator 

@ @<Imported packages@>=
import java.io.*;
import java.util.*;

@ Big picture: This is the layout of the wumpus class

@(wumpus.java@>=
  @<Imported packages@>
  public class wumpus
    { 
      @<variables@>
      @<Code for initialization@>
      @<Code for taking user string@>
      @<Code for taking user int@>
      @<Code for hunter move@>
      @<Code for hunter shoot@>
      @<Code for wumpus behavior@>
      @<Code for detecting hazard@>
      @<Code for checking suicide@>
      @<Code for game over@>
      @<Code for main frame@>
      @<Code for main()@>
      @<code for instruction@>
    }

@ Define global variables 

@ @<variables@>=
 int[][] cave;
 int bat1, bat2;
 int pit1, pit2;
 int wmps;
 int hunter, arrow, arrwnum;
 long seed, oldsd;
 boolean gameon;
 boolean win;
 boolean same=false;
 Random ran;

@* Initialization Section. This method initializes room numbers of |cave|, location of |bats|, |pits|, |wumpus| and |hunter|.
The basic frame is defined as below

@<Code for initialization@>=
 public void init(boolean putsame, long oldsd)
 {
  @<Cave@>  
  @<others@>
  @<random@>
  @<placing game var@>
  return;
  }

@ Cave has room 1 to 20, where each room is connected to three other rooms. 

@<Cave@>=
  cave=new int [][] {{2,5,8},{1,3,10},{2,4,12},{3,5,14},{1,4,6},
  {5,7,15},{6,8,17},{1,7,9},{8,10,18},{2,9,11},{10,12,19},{3,11,13},{12,14,20},
  {4,13,15},{6,14,16},{15,17,20},{7,16,18},{9,17,19},{11,18,20},{13,16,19}};

@ @<others@>=
  win=false;
  gameon=true;
  arrwnum=5;
  
@ @<random@>=
  if (putsame)
   seed = oldsd;
  else
    {seed = System.currentTimeMillis();
    oldsd = seed;}
  ran = new Random(seed);

@ @<placing game var@>=
  hunter=ran.nextInt(20)+1;
  wmps=ran.nextInt(20)+1;
  pit1=ran.nextInt(20)+1;
  pit2=ran.nextInt(20)+1;
  
  if (pit1==pit2)
  {while (pit1==pit2)
   pit2=ran.nextInt(20)+1;}
  bat1=ran.nextInt(20)+1;
  bat2=ran.nextInt(20)+1;
  
  if (bat1==bat2)
  {while (bat1==bat2)
   bat2=ran.nextInt(20)+1;}
   while (hunter==pit1||hunter==pit2||hunter==bat1||hunter==bat2)
    hunter=ran.nextInt(20)+1;

@* Taking User Input Section. This game takes two types of user input: 
1. Integer and 2. String (yes/no, shoot/move). Thus there are two methods for taking each
input type: {\bf UserStr} and {\bf Userint}. The general structures are shown below.

@ This method takes user string input and checks the validity of it. This method is called with
three parameters: question to be printed for the user and two valid expected user input, ex) 'y' and 'n'.

@<Code for taking user string@>=
  public String userStr(String q, String a, String b){
   Scanner inpt = new Scanner(System.in);
   System.out.println(q);
   String rsp = inpt.next();
   while (!(rsp.equals(a) || rsp.equals(b)))
    {System.out.print("Enter a valid answer: ");
     rsp = inpt.next();}
     return rsp;}

@ Take user integer input. 

@<try block@>=
    try{
      System.out.print(q);
      rsp = inpt.next();
      rspint = Integer.parseInt(rsp);
      if (rspint>0 && rspint<n+1)
      {again = false;}
      else if (rspint < 1 || rspint > n)
      {throw new NumberFormatException("Out of Bound!");}}

@ @<catch block@>=
   catch (NumberFormatException e1) {     
     System.out.print("ENTER A VALID, INTEGER INPUT\n");}
   catch (InputMismatchException e2) {
     System.out.print("ENTER A VALID, INTEGER INPUT\n");}

@ This is what the whole method looks like, combining every segment together:

@<Code for taking user int@>=
  public int userint(String q, int n)
  {Scanner inpt = new Scanner(System.in);
   String rsp;
   int rspint=0;
   boolean again = true;
   do{
   @<try block@>
   @<catch block@>
   } while(again);
   return rspint;}

@* Move. This method moves player to one of the three adjacent caves according to the
user input.

@ Check the validity of the user input.

@<changing hunter position@>=
   if (!(rsp==cave[hunter-1][0]||rsp==cave[hunter-1][1]||rsp==cave[hunter-1][2]))
   	{rsp = userint("You can only move to adjacent rooms. WHERE TO: ",20);}
   this.hunter = rsp;

@ Check if the hunter ended up in the same room with one of the |hazards|.

@<check bat hazard@>=
   while (hunter==bat1 || hunter==bat2)
   {System.out.print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!\n"); 
    this.hunter=ran.nextInt(20)+1;}

@ @<check pit hazard@>=
   if (hunter==pit1 || hunter==pit2)
   {System.out.print("YYYIIIIEEEE . . . FELL IN A PIT\n");   
    gameon=false;
    gameover();}

@ The final move method looks like below

@<Code for hunter move@>=
  public void move()
  {
  int rsp = this.userint("WHERE TO: ", 20);
  @<changing hunter position@>
  @<check bat hazard@>
  @<check pit hazard@>
   return;}

@* Wumpus' behavior. This method determines wumpus' move when it is disturbed by the hunter or
an arrow. There is 25% chance that the wumpus stays in the same room, 
and 75% chance it moves to other adjacent room. Its behavior is determined by a random number generator

@<determine random move@>=
     if ((ran.nextInt(100)+1)>25)
     {int temp=ran.nextInt(3);
      wmps = cave[wmps-1][temp];}

@<disturbed by hunter @>=
if (hunter==wmps)
    {@<determine random move@>
     else
     {win=false; 
      System.out.print("You were eaten by the wumpus! Sorry, you lost\n");
      gameon=false;
      gameover();}
      }
      
@ @<disturbed by arrow@>=     
   else if (arrow==wmps)
    {@<determine random move@>
     else
     {win=true;
      System.out.print("You just killed the wumpus! YAY! you won!\n");
      gameon=false;
      gameover();}}
      
@ So the whole method looks like 
      
@<Code for wumpus' behavior@>=
  public void wumps()
  {
    @<disturbed by hunter @>
    @<disturbed by arrow @> 
     return;}

@* Shoot. When the user decides to shoot, this method 
determines where the arrow will fly to by taking a user input.

@<take user input for arrow distance@>=
   System.out.print ("You can shoot through 5 rooms\n");
   int dist = userint("How many rooms do you want to shoot?",5);
   int next = -1;

@ @<if user input is valid, then change the position of arrow to that number@>
	next=userint("Where to?",20);
	if (next==cave[arrow-1][0]||next==cave[arrow-1][1]||next==cave[arrow-1][2])
	{for (int i=0; i<3; i++)
	{if (next==cave[arrow-1][i])
	 {arrow=next;
	  break;} } }

@ If the user input is not valid (i.e. not one of the three adjacent room), 
then arrow will end up in a random room  

@<If the user input is invalid, then arrow goes to a random room@>=
    else if (!(next==cave[arrow-1][0]||next==cave[arrow-1][1]||next==cave[arrow-1][2]))
   	{
   	 System.out.print("You can only shoot to adjacent rooms.\n"+
   	  "Your arrow ended up at a random room!\n");
   	  //arrow random move to among 3 rooms change!!!!!!!
   	  arrow = ran.nextInt(20)+1;
   	  System.out.print("arrow went to cave "+arrow+"\n");
   	  wumps();
   	  suicide();
	  break;
   	  }

@ @<check if the user used up all arrows@>=
   if (arrwnum==0)
   {
    System.out.print("You just used up all your arrows. You'll die. Sorry, You lost!\n");
    win=false;
    gameon=false;
    gameover();
    }

@ @<Code for hunter shoot@>=
  public void shoot()
  {@<take user input for arrow distance@>
   arrow=hunter;     
   for (int j=dist; j>0; j--)
   {@<if user input is valid, then change the position of arrow to that number@>
    @<If the user input is invalid, then arrow goes to a random room@>
   	 wumps();
   	 suicide();}
   System.out.print("You Missed! Sorry\n");
   arrwnum--;
   @<check if the user used up all the arrows@>
    return;}

@* Suicide. When the user input for shoot method is invalid, arrow can end up shooting the 
player himself since it can fly to any direction. 

@<Code for checking suicide@>=
  public void suicide()
  {if (arrow==hunter)
    {System.out.print("You Just Shoot Yourself in the Back! You Lost\n");
     win=false;
     gameon=false;
     gameover();}
   return;}

@* GameOver. This method is invoked when 1. the user got shot by his own arrow, 2. the 
user is out of arrow, and 3. wumpus is dead.

@<quit say bye@>=
   if ((rsp.equals("y")) || (rsp.equals("Y")))
    {System.out.print("Bye Bye\n");
     System.exit(0);}

@ @<new game with or without the same layout@>= 
    else
     {String rsp2 = userStr("Same Set-up?", "y","Y","n","N");
      if ((rsp2.equals("n"))||(rsp2.equals("N")))
       {same = false;
        game(same, oldsd);}
      else
       {same = true;
        game(same, oldsd);}}
  
@ @<Code for game over@>=
  public void gameover()
  {if (win)
    System.out.print("GAME ENDS - YOU WON\n");
   else
    System.out.print("GAME ENDS - YOU LOST\n");
   String rsp =  userStr("Do you want to quit?", "y","Y","n","N");
   @<quit say bye@>
   @<new game with or without the same layout@> }

@* Main Frame of the Game. This |game| method is the mainframe of the game.

@<Code for main frame@>=
  public void game(Boolean putsame2, long putoldsd2)
  { 
   System.out.print("Hello! Welcome to Hunt the Wumpus!\n");
   String rsp = userStr("Do you want to read the instruction? (Y-N)", "Y","y","n","N");
   if (rsp.equals("y")||rsp.equals("y"))
    instructions();
   init(putsame2, putoldsd2);
   while(gameon)
   { detector();
    System.out.print("You are in cave "+hunter+"\n");
    System.out.print("You can go to caves "+cave[hunter-1][0]+"  "
    +cave[hunter-1][1]+"  "+cave[hunter-1][2]+"\n");
    String sORm = userStr("SHOOT OR MOVE (S-M)","s","S","m","M");
    if (sORm.equals("s")||sORm.equals("S"))
     shoot();
    else if (sORm.equals("m")||sORm.equals("M"))
     move();}}
     
@* Hazard Detector. This method prints out warning messages if the hunter is near
hazards(pit, bat, and wumpus).
    
@<Code for detecting hazard@>=
  public void detector()
  {for (int i=0; i<3 ; i++)
   {if((cave[hunter-1][i]==bat1)||(cave[hunter-1][i]==bat2))
     System.out.print("BATS NEAR YOU\n");
    else if((cave[hunter-1][i]==pit1)||(cave[hunter-1][i]==pit2))
     System.out.print("I FEEL DRAFT..\n");
    else if (cave[hunter-1][i]==wmps)
     System.out.print("I SMELL A WUMPUS..\n");}}

@* Main. This is the |main()| method of the game class

@<Code for main()@>= 
  public static void main(String[] args)
  {wumpus test = new wumpus();
   test.game(test.same, test.oldsd);}
   
@* Instructions. Instruction for the user

@<first part instruction@>=
System.out.print("\n WELCOME TO HUNT THE WUMPUS \n"+
  "THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM HAS 3\n"+
"TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A DODECAHEDRON\n"+
"TO SEE HOW THIS WORKS-IF YOU DON'T KNOW WHAT A DODECAHEDRON\n"+
"IS, ASK SOMEONE\n");

@ @<second part instruction@>=
System.out.print("HAZARDS:\n"+
"BOTTOMLESS PITS - TWO ROOMS HAVE BOTTOMLESS PITS IN THEM.\n"+
"    IF YOU GO THERE, YOU FALL INTO THE PIT (AND LOSE!)\n"+
"SUPER BATS - TWO OTHER ROOMS HAVE SUPER BATS.  IF YOU\n"+
"    GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER\n"+
"    ROOM AT RANDOM.  (WHICH MIGHT BE TROUBLESOME)\n");

@ @<third part instruction@>=
System.out.print("WUMPUS:\n"+
"THE WUMPUS IS NOT BOTHERED BY THE HAZARDS (HE HAS SUCKER\n"+
"FEET AND IS TOO BIG FOR A BAT TO LIFT.)  USUALLY\n"+
"HE IS ASLEEP. TWO THINGS WAKE HIM UP: YOU’RE ENTERING\n"+
"HIS ROOM OR YOU’RE SHOOTING AN ARROW.\n"+
"IF THE WUMPUS WAKES, HE SOMETIMES RUNS TO THE NEXT ROOM.\n"+
"IF YOU HAPPEN TO BE IN THE SAME ROOM WITH HIM, YOU LOSE.\n");

@ @<fourth part instruction@>=
System.out.print("YOU:\n"+
"EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW.\n"+
"  MOVE: YOU CAN MOVE ONE ROOM (THROUGH ONE TUNNEL.)\n"+
"  SHOOT: YOU HAVE 5 ARROWS.  YOU LOSE WHEN YOU RUN OUT.\n"+
"  EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING\n"+
"  THE COMPUTER THE ROOM #'S YOU WANT THE ARROW TO GO TO.\n"+
"  IF THE ARROW CAN'T GO THAT WAY, IT MOVES AT RANDOM TO THE\n"+
"  NEXT ROOM.\n"+
"    IF THE ARROW HITS THE WUMPUS, YOU WIN.\n"+
"    IF THE ARROW HITS YOU, YOU LOSE.\n"+
"    WARNINGS:\n"+
"WHEN YOU ARE ONE ROOM AWAY FROM WUMPUS OR HAZARD, THE COMPUTER\n"+
"SAYS:\n"+
"WUMPUS - I SMELL A WUMPUS\n"+
"BAT    - BATS NEARBY\n"+
"PIT    - I FEEL A DRAFT\n"+
"HUNT THE WUMPUS\n\n");

@ Instruction method looks like below:

@<code for instruction@>=
  public void instructions()
  {
    @<first part instruction@>
    @<second part instruction@> 
    @<third part instruction@>
    @<fourth part instruction@> 
return; 
}

