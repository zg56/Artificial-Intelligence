package SlidingBlockPuzzle;

import java.util.*;

public class Node
{
    public int depth;
    public Node parent;
    public Game game;
    public Move move;
    public Node(Node _parent, Game _game, Move _move, int _depth)
    {
        parent = _parent;
        game = _game;
        move = _move;
        depth = _depth;
    }
}

