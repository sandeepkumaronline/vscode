import java.util.Scanner;
import java.util.Random;

public class BattleShipGame {
    public static void main(String[] args){
        char[][] grid = new char[12][14];
        System.out.println("** Welcome to the BATTLESHIP game **");
        System.out.println("Right now, the sea is empty.");
        createOceanMap(grid);
        display(grid);
        deployPlayerShip(grid);
        deployCompShip(grid);
        int[]ships = {5,5};
        while(!isGameOver(ships)) battle(grid,ships); }

    public static void createOceanMap(char[][] grid){
        grid[0][0]=' ';
        grid[0][1]=' ';
        grid[0][12]=' ';
        grid[0][13]=' ';
        grid[11][0]=' ';
        grid[11][1]=' ';
        grid[11][12]=' ';
        grid[11][13]=' ';
        for(int j=2;j<=11;++j) {
            grid[0][j] = (char)(48 +j - 2); // ASCII CODE OF int 0 is 48
            grid[11][j] =(char)(48 + j-2);
        }
        for(int i=1;i<=10;++i) {
            grid[i][0]=(char)(48 + i - 1);
            grid[i][13] =(char)(48 + i - 1);
            grid[i][1]='|';
            grid[i][12]='|';
        }
        for(int i=1;i<=10;++i)
            for(int j=2;j<=11;++j)
                grid[i][j]=' ';
    }

    public static void display(char[][] grid){
        for(int i=0; i<grid.length; ++i){
            for(int j=0;j<grid[0].length;++j){
                if((i==0&&j==4)||(i==13&&j==4)||(i==3&&j==0)||(i==3&&j==13))
                    System.out.print("2" + "     ");
                else if((grid[i][j]=='2' || grid[i][j]=='0') && i>=1 && i<=10 && j>=2 && j<=11)
                    System.out.print("  " + "    ");
                else
                    System.out.print(grid[i][j] + "     ");
            }
            System.out.println(" ");
        }
    }

    public static void deployPlayerShip(char[][] grid){
        Scanner input = new Scanner(System.in);
        int i,j;
        System.out.println("Deploy your ships.");
        for(int n=1;n<=5;++n){
            System.out.print("Enter X coordinate of your " + n + ". ship : ");
            i=input.nextInt();
            System.out.print("Enter Y coordinate of your " + n + ". ship : ");
            j=input.nextInt();
            while(i<0 || i>9 || j<0 || j>9 || grid[i+1][j+2] =='@'){
                System.out.println("Invalid Coordinates or Already Occupied.");
                System.out.print("Enter X coordinate of your " + n + ". ship : ");
                i=input.nextInt();
                System.out.print("Enter Y coordinate of your " + n + ". ship : ");
                j=input.nextInt();
            }
            grid[i+1][j+2]='@';
        }
        display(grid);
    }

    public static void deployCompShip(char[][] grid) {
        Random rand = new Random();
        int i,j;
        System.out.println("Computer is deploying ships.");
        for(int n=1;n<=5;++n) {
            i = Math.abs(rand.nextInt())%10;
            j = Math.abs(rand.nextInt())%10;
            while(grid[i+1][j+2] =='@' || grid[i+1][j+2]=='2'){
                i = Math.abs(rand.nextInt())%10;
                j = Math.abs(rand.nextInt())%10;
            }

            System.out.println(n + ". ship DEPLOYED. ");
            grid[i+1][j+2]='2';
        }
    }

    public static void battle(char[][] grid, int[] ships){

        int x,y;
        Random rand = new Random();
        Scanner input = new Scanner(System.in);
        System.out.println("====Your Turn====");
        System.out.print("Choose the target's X coordinate : ");
        x = input.nextInt();
        System.out.print("And Y coordinate : ");
        y = input.nextInt();
        while(!isValidCoord(grid,x,y)){
            System.out.println("Invalid Coordinates or Already selected");
            System.out.print("Choose X = ");
            x = input.nextInt();
            System.out.print("Choose Y = ");
            y = input.nextInt();
        }
        switch(grid[x+1][y+2]){
            case '2':
                --ships[1];
                grid[x+1][y+2] = '!';
                System.out.println("BOOM! You sunk the ship!");
                break;
            case '@':
                --ships[0];
                grid[x+1][y+2] = 'X';
                System.out.println("Oh no! You sunk your own ship :(");
                break;
            case ' ':
            case '0':
                grid[x+1][y+2] = '-';
                System.out.println("Sorry! You missed.");
        }
        System.out.println("==== Computer's Turn ====");
        x = Math.abs(rand.nextInt())%10;
        y = Math.abs(rand.nextInt())%10;
        while(!isValidCoord(grid,x,y)){
            x = Math.abs(rand.nextInt())%10;
            y = Math.abs(rand.nextInt())%10;
        }
        switch(grid[x+1][y+2]){
            case '@':
                --ships[0];
                grid[x + 1][y + 2] = 'X';
                System.out.println("The Computer sunk one of your ships.");
                break;
            case '2':
                --ships[1];
                grid[x + 1][y + 2] = '!';
                System.out.println("Lucky! The Computer sunk one of its own ships.");
                break;
            case ' ':
                System.out.println("Computer missed.");
                grid[x + 1][y + 2] = '0';
        }
        display(grid);
    }// End of battle(char[][],int[])

    public static boolean isValidCoord(char[][] grid, int x, int y){
        if(x>=0 && x<=9 && y>=0 && y<=9){
            if(grid[x+1][y+2]=='!' || grid[x+1][y+2]=='X' || grid[x+1][y+2]=='-')
                return false;
            else
                return true;
        }else
            return false;
    }
    public static boolean isGameOver(int[] ships) {
        if(ships[0]>0 && ships[1]>0)
            return false;
        else{
            if(ships[1]==0){
                System.out.println("Your Ships : " + ships[0] + "| Computer Ships : " + ships[1]);
                System.out.println("Hooray! You won the battle:)");
                return true;
            }else{
                System.out.println("Your Ships : " + ships[0] + "| Computer Ships : " + ships[1]);
                System.out.println("Sorry! You Loose(:");
                return true;
            }
        }
    }
}