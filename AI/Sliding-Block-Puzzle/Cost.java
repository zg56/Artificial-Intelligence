package SlidingBlockPuzzle;

import java.io.*;
import java.util.*;

public abstract class Cost
{
    public abstract double getCost(Game game);

    protected ArrayList<Double> getAverageLocation(Game game, int numPiece) {
        ArrayList <Double> average = new ArrayList<Double>();
        ArrayList <Point> location = game.getLocation(numPiece);
        double x = 0, y = 0;
        for(Point p : location) {
            x += p.Row;
            y += p.Column;
        }

        average.add( (1.0 * x) / location.size() );
        average.add( (1.0 * y) / location.size() );

        return average;
    }
}

