require 'byebug'
MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0],
  upright: [-1, 1],
  upleft: [-1, -1],
  downright: [1, 1],
  downleft: [1, -1],
  knight1: [1, 2],
  knight2: [1, -2],
  knight3: [-1, 2],
  knight4: [-1, -2],
  knight5: [2, 1],
  knight6: [2, -1],
  knight7: [-2, 1],
  knight8: [-2, -1]
}

#(Bishop/Rook/Queen)
module SlidingPiece
  def moves
    move_dirs = self.move_dirs
    valid_moves = []
    move_dirs.each do |dir|
      single_move = MOVES[dir]
      end_pos = self.get_new_pos(self.pos, single_move)
      until self.board.illegal_move?(self.pos, end_pos)
        valid_moves << end_pos
        break  if self.board.capture_move?(self.pos, end_pos)
        end_pos = self.get_new_pos(end_pos, single_move)
      end
    end
    valid_moves
  end
end

module SteppingPiece
  def moves
    move_dirs = self.move_dirs
    valid_moves = []
    move_dirs.each do |dir|
      single_move = MOVES[dir]
      end_pos = get_new_pos(self.pos, single_move)
      unless self.board.illegal_move?(self.pos, end_pos)
        valid_moves << end_pos
      end
    end
    valid_moves
  end
end
