import java.util.List;


public class OthelloZoltan extends OthelloPlayer {

	 	private final int MAX=Integer.MAX_VALUE;
	    private final int MIN=Integer.MIN_VALUE;
		private int player;
		private int depth;
		
		public OthelloZoltan()
		{
			player = 0;
			depth = 5;
			
		}
		
		public OthelloZoltan(int _player, int _depth)
		{
			player = _player;
			depth = _depth;
		}
		

		@Override
		public OthelloMove getMove(OthelloState state) {
			if(player == OthelloState.PLAYER1)
			{
				List<OthelloMove> moves = state.generateMoves();
                if(moves.isEmpty())
                {
                    return null;
                }

				int value = MIN;
				int index = -1;
				for(int i=0; i<moves.size(); i++) 
				{
					int v = getMin(state.applyMoveCloning(moves.get(i)), depth);
					if(value < v) 
					{
						value = v;
						index = i;
					}
				}
				if(index != -1) 
					return moves.get(index);
					
				return null;				
			}
			else
			{
				List<OthelloMove> moves = state.generateMoves();
                if(moves.isEmpty())
                {
                    return null;
                }

				int value = MAX;
				int index = -1;
				for(int i=0; i<moves.size(); i++) 
				{
					int v = getMax(state.applyMoveCloning(moves.get(i)), depth);
					if(v < value) 
					{
						value = v;
						index = i;
					}
					
				}
				if(index != -1) 
					return moves.get(index);
				
				return null;
			}
		}
		
		private int getMin(OthelloState state, int depth)
		{
			if(depth != 0 )
            {
			List<OthelloMove> moves = state.generateMoves();
			if(moves.isEmpty())
            {
				return getMax(state.applyMoveCloning(null), depth-1);
            }

			int min = MAX;
			for(OthelloMove move : moves) 
            {
				int value = getMax(state.applyMoveCloning(move), depth-1);
				if(min > value)
                {
                    min = value;
                }
                else
                {
                    min = min;
                }
			}
            if (state.gameOver())
            {
                return state.score();
            }
			
			return min;
            }
            else 
            {
                return state.score();
            }
		}
		
		private int getMax(OthelloState state, int depth)
		{
			if(depth != 0)
            {

			List<OthelloMove> moves = state.generateMoves();
			if(moves.isEmpty())
            {
				return getMin(state.applyMoveCloning(null), depth-1);
            }
			int max = MIN;
			for(OthelloMove move : moves) 
            {
				int value = getMin(state.applyMoveCloning(move), depth-1);

                if(max < value)
                {
                    max = value;
                }
                else
                {
                    max = max;
                }
			}
            if(state.gameOver())
            {
                return state.score();
            }
			return max;
            }
            else
            {
                return state.score();
            }
		}

}
