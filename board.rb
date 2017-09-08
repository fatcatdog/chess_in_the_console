require_relative 'piece'
require 'byebug'
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8)
    grid.each_index do |i|
      case i
      when 0, 7
        grid[i] = get_pieces(i, self)
      when 1, 6
        grid[i] = get_pawns(i, self)
      else
        grid[i] = get_null_pieces(i, self)
      end
    end
  end

  def get_pieces(row, board)
    color = row == 0 ? :black : :white
    pieces = Array.new(8)
    pieces[0] = Rook.new(color, [row,0], board)
    pieces[1] = Knight.new(color, [row,1], board)
    pieces[2] = Bishop.new(color, [row,2], board)
    pieces[3] = Queen.new(color, [row,3], board)
    pieces[4] = King.new(color, [row,4], board)
    pieces[5] = Bishop.new(color, [row,5], board)
    pieces[6] = Knight.new(color, [row,6], board)
    pieces[7] = Rook.new(color, [row,7], board)
    pieces
  end

  def get_pawns(row, board)
    color = row == 1 ? :black : :white
    pieces = Array.new(8) { |i| Pawn.new(color, [row, i], board)}
    pieces
  end

  def get_null_pieces(row, board)
    pieces = Array.new(8) { |i| NullPiece.instance }
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []= (pos, value)
    x, y = pos
    grid[x][y] = value
  end
      #will need to update when capture logic is implimented
  def move_piece(start_pos, end_pos)
    raise InvalidMoveError unless valid_move?(start_pos, end_pos)
    if capture_move?(start_pos, end_pos)
      self[end_pos]  = self[start_pos]
      self[start_pos] = NullPiece.instance
    else
      self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
    end
    self[end_pos].pos = end_pos
  end

  def move_piece!(start_pos, end_pos)
    if capture_move?(start_pos, end_pos)
      self[end_pos]  = self[start_pos]
      self[start_pos] = NullPiece.instance
    else
      self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
    end
    self[end_pos].pos = end_pos
  end

  def valid_move?(start_pos, end_pos)
    return false unless self[start_pos].moves.include?(end_pos)
    copy = self.deep_dup
    copy.move_piece!(start_pos, end_pos)
    !copy.in_check?(self[start_pos].color)
  end

  def illegal_move? (start_pos, end_pos)
    return true if end_pos == start_pos
    return true if self[start_pos].is_a?(NullPiece)
    return true unless in_bounds?(end_pos) && in_bounds?(start_pos)
    return true if self[end_pos].color == self[start_pos].color
    false
  end

  def capture_move?(start_pos, end_pos)
    !illegal_move?(start_pos, end_pos) && self[start_pos].color != self[end_pos].color && !self[end_pos].is_a?(NullPiece)
  end

  def in_bounds?(pos)
    pos.all? { |coordinate| coordinate.between?(0, 7) }
  end

  def in_check?(color)
    grid.each_index do |i|
      grid.each_index do |j|
        piece = self[[i, j]]
        next if piece.color == color
        piece_moves = piece.moves
        piece_moves.each do |end_pos|
          attacked = self[end_pos]
          return true if attacked.is_a?(King) && attacked.color == color
        end
      end
    end
    return false
  end

  def checkmate?(color)
    return false unless in_check?(color)

    grid.each_index do |i|
      grid.each_index do |j|
        piece = self[[i, j]]
        next if piece.color != color
        piece_moves = piece.moves
        piece_moves.each do |end_pos|
          copy = self.deep_dup
          copy.move_piece!(piece.pos, end_pos)
          return false unless copy.in_check?(color)
        end
      end
    end
    true
  end

  def deep_dup
    Marshal.load(Marshal.dump(self))
  end


end

class InvalidMoveError < StandardError
end
