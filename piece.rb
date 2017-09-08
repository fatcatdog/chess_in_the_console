require_relative "piece_modules.rb"
require "singleton"
require 'byebug'

class Piece
attr_reader :color, :board
attr_accessor :pos

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def to_s
    'P'
  end

  def get_new_pos(pos, diff)
    x, y = pos
    diff_x, diff_y = diff
    new_pos = [x + diff_x, y + diff_y]
  end
end


class NullPiece < Piece
  include Singleton

  def moves
    []
  end

  def initialize
  end

  def color
    nil
  end

  def to_s
    "\u25a1"
  end
end

class Rook < Piece
  include SlidingPiece

  def move_dirs
    [:left, :right, :up, :down]
  end

  def to_s
    self.color == :white ? "\u2656" : "\u265c"
  end
end

class Bishop < Piece
  include SlidingPiece

  def move_dirs
    [:upleft, :upright, :downleft, :downright]
  end

  def to_s
    self.color == :white ? "\u2657" : "\u265d"
  end
end

class Queen < Piece
  include SlidingPiece

  def move_dirs
    [:left, :right, :up, :down, :upleft, :upright, :downleft, :downright]
  end

  def to_s
    self.color == :white ? "\u2655" : "\u265b"
  end
end

class King < Piece
  include SteppingPiece

  def move_dirs
    [:left, :right, :up, :down, :upleft, :upright, :downleft, :downright]
  end
  def to_s
    self.color == :white ? "\u2654" : "\u265a"
  end
end

class Knight < Piece
  include SteppingPiece

  def move_dirs
    [:knight1, :knight2, :knight3, :knight4, :knight5, :knight6, :knight7, :knight8]
  end

  def to_s
    self.color == :white ? "\u2658" : "\u265e"
  end
end

class Pawn < Piece
  attr_reader :reg_move_dir, :capture_move_dirs

  def initialize(color, pos, board)
    super
    if self.color == :white
      @reg_move_dir = :up
      @capture_move_dirs = [:upleft, :upright]
    else
      @reg_move_dir = :down
      @capture_move_dirs = [:downleft, :downright]
    end
  end

  def to_s
    self.color == :white ? "\u2659" : "\u265f"
  end

  def moves
    valid_moves = []
    single_move = MOVES[reg_move_dir]
    single_end_pos = get_new_pos(self.pos, single_move)
    double_end_pos = get_new_pos(single_end_pos, single_move)
    poss_end_pos = [single_end_pos]

    if (self.pos[0] == 1) || (self.pos[0] == 6)
      poss_end_pos += [double_end_pos]
    end

    poss_end_pos.each do |pos|
      break if self.board.capture_move?(self.pos, pos)
      valid_moves << pos
    end

    capture_move_dirs.each do |dir|
      single_move = MOVES[dir]
      end_pos = get_new_pos(self.pos, single_move)
      if self.board.capture_move?(self.pos, end_pos)
        valid_moves << end_pos
      end
    end

    valid_moves
  end
end
