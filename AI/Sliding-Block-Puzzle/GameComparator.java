package SlidingBlockPuzzle;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class GameComparator implements Comparator<Node>
{
    private Cost cost;
    public GameComparator(Cost _cost)
    {
        cost = _cost;
    }

    public int compare(Node n1, Node n2)
    {
        double cost1 = cost.getCost(n1.game) + n1.depth;
        double cost2 = cost.getCost(n2.game) + n2.depth;
        if(cost1 > cost2)
            return 1;
        else if(cost1 < cost2)
            return -1;
        return 0;
    }
}

