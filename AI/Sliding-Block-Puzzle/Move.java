package SlidingBlockPuzzle;

public class Move 
{
    public int piece;
    public Direction direction;

    public Move(int _piece, Direction _direction) {
        piece = _piece;
        direction = _direction;
    }

    public boolean isEqual(Move other_move) {
        if(piece == other_move.piece && direction == other_move.direction) return true;
        return false;
    }

    public void display() {
        System.out.println("Move(" + piece + ", " + direction + ")");
    }
}

