package SlidingBlockPuzzle;

import java.io.*;
import java.util.*;
import java.lang.*;

public class ManhattanCost extends Cost
{
    public double getCost(Game game) {
        ArrayList <Double> gate = getAverageLocation(game, -1);
        ArrayList <Double> target = getAverageLocation(game, 2);
        double xdiff = gate.get(0)-target.get(0);
        double ydiff = gate.get(1)-target.get(1);

        return Math.sqrt(xdiff*xdiff + ydiff*ydiff);
    }
}

