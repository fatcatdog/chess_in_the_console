require_relative "board"
require_relative "display"
require "byebug"

class Game
  attr_reader :board, :display
  attr_accessor :current_player, :next_player

  def initialize
    @board = Board.new
    @display = Display.new(board)
    @current_player = :white
    @next_player = :black
  end

  def play
    until board.checkmate?(:black) || board.checkmate?(:white)
      play_turn
      switch_players
    end
    system("clear")
    display.render
    puts "CHECKMATE. #{next_player} wins!"
  end

  def play_turn
    start_pos = nil
    end_pos = nil

    loop do
      system("clear")
      display.render
      puts current_player
      return_val = display.cursor.get_input
      next if return_val.nil?
      if start_pos.nil?
        start_pos = return_val
        next
      else
        end_pos = return_val
      end

      begin
        if current_player != board[start_pos].color
          raise InvalidMoveError
        end
        board.move_piece(start_pos, end_pos)
      rescue InvalidMoveError
        start_pos = nil
        end_pos = nil
        next
      end

      if board.in_check?(:white) || board.in_check?(:black)
        puts "CHECK"
        sleep(1)
      end
      break

    end
  end

  def switch_players
    self.current_player, self.next_player = next_player, current_player
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
