package SlidingBlockPuzzle;

import java.util.*;

public class Strategy
{
    public void randomWalk(Game game, int n) {
        Random rand = new Random();
        game.display();
        for(int i = 0; i < n; i++) {
            ArrayList<Move> moves = game.getAllPossibleMoves();
            int randomInt = rand.nextInt(moves.size());
            System.out.println("[" + i + " trial]");
            moves.get(randomInt).display();
            game.applyMove(moves.get(randomInt));
            game.normalize();
            game.display();
            if(game.isGameOver()) return;
        }
    } 

    public ArrayList<Move> bfSearch(Game game) {
        Node current = new Node(null, game, null, 0);

        ArrayList<Game> explored = new ArrayList<Game>();
        Queue<Node> frontier = new LinkedList<Node>();

        explored.add(game);
        frontier.add(current);

        while(!current.game.isGameOver() && !frontier.isEmpty()) {
            current = frontier.remove();
            Game cg = current.game; // current game
            int cd = current.depth;
            ArrayList<Move> possible = cg.getAllPossibleMoves();

            for(Move m : possible) {
                Game ng = cg.applyMoveClone(m);
                if(!isExplored(explored, ng)) {
                    explored.add(ng);
                    frontier.add(new Node(current, ng, m, cd+1));
                }
            }
        }

        Stack<Move> opposit = new Stack<Move>();
        if(current.game.isGameOver())
            while(current.parent != null) {
                opposit.push(current.move);
                current = current.parent;
            }

        ArrayList<Move> moves = new ArrayList<Move>();
        while(!opposit.isEmpty())
            moves.add(opposit.pop());

        return moves;
    }


    public ArrayList<Move> dfSearch(Game game) {
        Node current = new Node(null, game, null, 0);

        ArrayList<Game> explored = new ArrayList<Game>();
        Stack<Node> frontier = new Stack<Node>();

        explored.add(game);
        frontier.push(current);

        while(!current.game.isGameOver() && !frontier.isEmpty()) {
            current = frontier.pop();
            Game cg = current.game; // current game
            int cd = current.depth;
            ArrayList<Move> possible = cg.getAllPossibleMoves();

            for(Move m : possible) {
                Game ng = cg.applyMoveClone(m);
                if(!isExplored(explored, ng)) {
                    explored.add(ng);
                    frontier.push(new Node(current, ng, m, cd+1));
                }
            }
        }

        Stack<Move> opposit = new Stack<Move>();
        if(current.game.isGameOver())
            while(current.parent != null) {
                opposit.push(current.move);
                current = current.parent;
            }

        ArrayList<Move> moves = new ArrayList<Move>();
        while(!opposit.isEmpty())
            moves.add(opposit.pop());

        return moves;
    }


    public ArrayList<Move> dlSearch(Game game, int maxdepth) {
        Node current = new Node(null, game, null, 0);

        ArrayList<Game> explored = new ArrayList<Game>();
        Stack<Node> frontier = new Stack<Node>();

        explored.add(game);
        frontier.push(current);

        while(!current.game.isGameOver() && !frontier.isEmpty()) {
            current = frontier.pop();
            Game cg = current.game; // current game
            int cd = current.depth;
            ArrayList<Move> possible = cg.getAllPossibleMoves();

            for(Move m : possible) {
                Game ng = cg.applyMoveClone(m);
                if(!isExplored(explored, ng) && maxdepth >= cd) {
                    explored.add(ng);
                    frontier.push(new Node(current, ng, m, cd+1));
                }
            }
        }

        Stack<Move> opposit = new Stack<Move>();
        if(current.game.isGameOver())
            while(current.parent != null) {
                opposit.push(current.move);
                current = current.parent;
            }

        ArrayList<Move> moves = new ArrayList<Move>();
        while(!opposit.isEmpty())
            moves.add(opposit.pop());

        return moves;
    }

    public ArrayList<Move> aStarSearch(Game game, Cost cost) {
        Comparator<Node> comparator = new GameComparator(cost);

        Node current = new Node(null, game, null, 0);

        ArrayList<Game> explored = new ArrayList<Game>();
        PriorityQueue<Node> frontier = new PriorityQueue<Node>(10, comparator);

        explored.add(game);
        frontier.add(current);

        while(!current.game.isGameOver() && !frontier.isEmpty()) {
            current = frontier.remove();
            Game cg = current.game; // current game
            int cd = current.depth;
            ArrayList<Move> possible = cg.getAllPossibleMoves();

            for(Move m : possible) {
                Game ng = cg.applyMoveClone(m);
                if(!isExplored(explored, ng)) {
                    explored.add(ng);
                    frontier.add(new Node(current, ng, m, cd+1));
                }
            }
        }

        Stack<Move> opposit = new Stack<Move>();
        if(current.game.isGameOver())
            while(current.parent != null) {
                opposit.push(current.move);
                current = current.parent;
            }

        ArrayList<Move> moves = new ArrayList<Move>();
        while(!opposit.isEmpty())
            moves.add(opposit.pop());

        return moves;
    }


    public ArrayList<Move> idSearch(Game game) {
        int i = 0;
        ArrayList<Move> moves = new ArrayList<Move>();
        while(moves.size() == 0) {
            moves = dlSearch(game, i);
            i++;
        }
        return moves;
    }

   
    private boolean isExplored(ArrayList<Game> games, Game game)
    {
        for(Game g : games) {
            if(g.compare(game))
                return true;
        }
        return false;
    }
}

