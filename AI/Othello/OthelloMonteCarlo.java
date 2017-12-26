import java.util.List;


public class OthelloMonteCarlo extends OthelloPlayer {

    private class OthelloNode {

        private OthelloNode parent;
        private ArrayList<OthelloNode> children = new ArrayList;
        private OthelloState state;
        private ArrayList<OthelloMove> moves = new ArrayList<OthelloMove>();
        private int visitedNodes;
        private int totalScore;

        public OthelloNode(OthelloState _state, OthelloNode _parent, OthelloMove _move){
        parent = parent;
        children = new ArrayList<OthelloNode>();
        state = _state;
        moves = generateMoves();
        visitedNodes = 0;
        totalScore = 0;
        
        }

    }

}
