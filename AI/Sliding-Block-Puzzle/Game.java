package SlidingBlockPuzzle;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class Game 
{
    private int nRow;
    private int nCol;
    private int[][] board;
    public Set<Integer> pieces;

    // create file from file
    public Game(String filename) throws Exception {
        ArrayList< ArrayList<Integer> > intBoard = parseFile(filename);

        nRow = intBoard.get(0).get(1);
        nCol = intBoard.get(0).get(0);
        board = new int[nRow][nCol];
        pieces = new HashSet<Integer>();

        for(int i=0; i<nRow; i++)
            for(int j=0; j<nCol; j++) {
                board[i][j] = intBoard.get(1+i).get(j);
                pieces.add(board[i][j]);
            }
    }

    // create file from board
    public Game(int[][] _board) {
        nRow = _board.length;
        nCol = _board[0].length;
        board = new int[nRow][nCol];
        pieces = new HashSet<Integer>();

        for(int i=0; i<nRow; i++)
            for(int j=0; j<nCol; j++) {
                board[i][j] = _board[i][j];
                pieces.add(board[i][j]);
            }
    }

    // return board
    public int[][] getBoard() {
        int[][] copy_board = new int[nRow][nCol];
        for(int i=0; i<nRow; i++)
            for(int j=0; j<nCol; j++)
                copy_board[i][j] = board[i][j];
        return copy_board;
    }

    public boolean isGameOver() {
        for(int i=0; i<nRow; i++)
            for(int j=0; j<nCol; j++)
                if(board[i][j] == -1)
                    return false;
        return true;
    }

    public ArrayList<Move> getPossibleMoves(int piece) {
        ArrayList<Move> possible = new ArrayList<Move>();

        if(piece == 0 || piece == 1 || piece == -1 || !pieces.contains(piece)) return possible;

        ArrayList<Move> moves = new ArrayList<Move>();
        moves.add(new Move(piece, Direction.UP));
        moves.add(new Move(piece, Direction.DOWN));
        moves.add(new Move(piece, Direction.LEFT));
        moves.add(new Move(piece, Direction.RIGHT));
        for(Move m : moves)
            if(isMovable(m)) possible.add(m);
        return possible;
    }

    public ArrayList<Move> getAllPossibleMoves() {
        ArrayList<Move> possible = new ArrayList<Move>();
        for(int i : pieces) {
            ArrayList<Move> moves = getPossibleMoves(i);
            for(Move m : moves) possible.add(m);
        }
        return possible;
    }

    public void display() {
        System.out.println("(nRow, nCol) = (" + nRow + ", " + nCol + ")");
        for(int i=0; i<nRow; i++) {
            for(int j=0; j<nCol; j++)
                System.out.print(board[i][j] + " ");
            System.out.println();
        }
    }

    private ArrayList< ArrayList<Integer> > parseFile(String filename) throws IOException {
        ArrayList< ArrayList<Integer> > intBoard = new ArrayList< ArrayList<Integer> >();
        List<String> strBoard = Files.readAllLines(Paths.get(filename));
        for(String s : strBoard) {
            String[] split = s.split(",");
            ArrayList<Integer> line = new ArrayList<Integer>();
            for(String element : split) line.add(Integer.valueOf(element));
            intBoard.add(line);
        }
        return intBoard;
    }

    private boolean isMovable(Move move) {
        if( !pieces.contains(move.piece) ) return false;

        int dRow = 0;
        int dCol = 0;

        switch(move.direction) {
        case UP: dRow = -1; break;
        case DOWN: dRow = 1; break;
        case LEFT: dCol = -1; break;
        default: dCol = 1;
        }

        for(int i=0; i<nRow; i++) {
            for(int j=0; j<nCol; j++) {
                int mRow = i+dRow;
                int mCol = j+dCol;

                if(board[i][j] == move.piece) {
                    if(mRow < 0 || mRow >= nRow || mCol < 0 || mCol >= nCol)
                        return false;
                    if(board[mRow][mCol] != 0 && board[mRow][mCol] != move.piece)
                        if(board[i][j] != 2 || board[mRow][mCol] != -1) 
                            return false;
                }
            }
        }
        return true;
    }

    
    // get piece location
    public ArrayList <Point> getLocation(int numPiece){
        ArrayList <Point> location = new ArrayList<Point>();

        if(!pieces.contains(numPiece)) return location;

        for (int i = 0; i < nRow; i++) { 
            for (int j = 0; j < nCol; j++) {
                if (numPiece == board[i][j])
                    location.add(new Point(i, j));
            }
        }
        return location;
    }


    // change piece number of location to number
    private void changeNum(int origin_num, int update_num){
        ArrayList<Point> location = getLocation(origin_num);
        for(Point p : location)
            board[p.Row][p.Column] = update_num;
        pieces.remove(origin_num);
        pieces.add(update_num);
    }


    // applymove
    public boolean applyMove(Move move) {
        ArrayList<Move> possible = getAllPossibleMoves();
        boolean flag = true;
        for(Move m : possible) {
            if(m.isEqual(move))
                flag = false;
        }
        if(flag) return false;

        int dRow = 0;
        int dCol = 0;

        switch(move.direction) {
        case UP: dRow = -1; break;
        case DOWN: dRow = 1; break;
        case LEFT: dCol = -1; break;
        default: dCol = 1;
        }

        ArrayList<Point> location = getLocation(move.piece);
        changeNum(move.piece, -2);
        for(Point p : location)
            board[p.Row + dRow][p.Column + dCol] = move.piece;
        changeNum(-2, 0);
        pieces.add(move.piece);
        return true;
    }

    // apply move clone
    public Game applyMoveClone(Move move) {
        Game copy_game = new Game(board);
        copy_game.applyMove(move);
        return copy_game;
    }


    // make the swap of the pices
    private void swapIndex(int piece1, int piece2) {
        changeNum(piece1, -2);
        changeNum(piece2, piece1);
        changeNum(-2, piece2);
    }


    // compare board
    public boolean compare(Game game) {
        int[][] other_board = game.getBoard();
        int r = other_board.length;
        int c = other_board[0].length;

        if(nRow != r || nCol != c)
            return false;

        for(int i = 0; i < nRow; i++)
            for(int j = 0; j < nCol; j++)
                if(board[i][j] != other_board[i][j])
                   return false;
        return true; 
    }


    public void normalize() {
        int nextIndex = 3;
        for(int i = 0; i < nRow; i++) {
            for(int j = 0; j < nCol; j++) {
                if(board[i][j] == nextIndex) nextIndex++;
                else if(board[i][j] > nextIndex) {
                    swapIndex(board[i][j], nextIndex);
                    nextIndex++;
                }
            }
        }
    }
}

