package SlidingBlockPuzzle;

import java.io.*;
import java.util.*;
import java.lang.*;

public class Heuristic extends Cost
{
    public double getCost(Game game) {
        ArrayList <Double> gate = getAverageLocation(game, -1);
        ArrayList <Double> target = getAverageLocation(game, 2);
        double xdiff = gate.get(0)-target.get(0);
        double ydiff = gate.get(1)-target.get(1);
        double distance =  Math.sqrt(xdiff*xdiff + ydiff*ydiff);

        int count = 0;
        ArrayList<Double> costs = new ArrayList<Double>();
        for(double c : costs)
            if(c < distance) count++;

        return 1.0 * count;
    }

    private ArrayList<Double> getAllCost(Game game) {
        Set<Integer> pieces = game.pieces;
        ArrayList<Double> costs = new ArrayList<Double>();

        ArrayList <Double> gate = getAverageLocation(game, -1);
        for(int p : pieces) {
            ArrayList <Double> target = getAverageLocation(game, p);
            double xdiff = gate.get(0)-target.get(0);
            double ydiff = gate.get(1)-target.get(1);
            double distance = Math.sqrt(xdiff*xdiff + ydiff*ydiff);
            costs.add(distance);
        }
        return costs;
    }
}

