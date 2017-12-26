package SlidingBlockPuzzle;

import java.io.*;
import java.util.*;

public class App 
{
    public static void main( String[] args )
    {
        try {
            String filename = args[0];
            Strategy strategy = new Strategy();

            Game game = new Game(filename);
            ArrayList<Move> moves = strategy.aStarSearch(game, new ManhattanCost());
            System.out.println("A Star Search with Manhattan distance:");            
            printResult(game, moves);


            System.out.println("======================================="); 
            System.out.println("======================================="); 
            System.out.println("======================================="); 
            System.out.println("======================================="); 
            System.out.println("======================================="); 

            Game game3= new Game(filename);
            ArrayList<Move> moves3 = strategy.aStarSearch(game3, new Heuristic());
            System.out.println("A Star Search with custom heuristic:");
            printResult(game3, moves3);


            System.out.println("======================================="); 
            System.out.println("======================================="); 
            System.out.println("======================================="); 
            System.out.println("======================================="); 
            System.out.println("======================================="); 


           // Game game2 = new Game(filename);
           // ArrayList<Move> moves2 = strategy.bfSearch(game2);
           // System.out.println("BF Search");            
           // printResult(game2, moves2);

        }
        catch(IOException exception) {
            System.out.println("IOException");
        }
        catch(Exception exception) {
            System.out.println("Exception");
        }
    }

    public static void printResult(Game game, ArrayList<Move> moves)
    {
        int depth = 1;
        game.display();
        for(Move m : moves) {
            m.display();
            game.applyMove(m);
            game.display();
            System.out.println("depth => " + depth);
            depth++;
        }
    }
}

