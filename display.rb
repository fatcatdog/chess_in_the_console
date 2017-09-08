require 'colorize'
require_relative 'board'
require_relative 'cursor'

class Display
  attr_reader :board, :cursor

  def initialize(board, cursor_pos=[0,0])
    @board = board
    @cursor = Cursor.new(cursor_pos, board)
  end

  def render
    board.grid.length.times do |i|
      board.grid.length.times do |j|
        pos = [i, j]
        rendered_piece  = board[pos].to_s
        if pos == cursor.cursor_pos
          color = :red
        else
          color = :black
        end
        print rendered_piece.colorize(color)
      end
      print "\n"
    end
  end

  def move_cursor_around
    start_pos = nil
    end_pos = nil

    loop do
      system("clear")
      render
      return_val = cursor.get_input
      unless return_val.nil?
        if start_pos.nil?
          start_pos = return_val
        else
          end_pos = return_val
        end
      end

      unless start_pos.nil? || end_pos.nil?
        board.move_piece(start_pos, end_pos)
        if board.checkmate?(:white)
          print "CHECK MATE"
          sleep(1)
        end

        if board.in_check?(:white)
          print "CHECK"
          sleep(1)
        end

        start_pos = nil
        end_pos = nil
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  display = Display.new(board)
  display.move_cursor_around
end
