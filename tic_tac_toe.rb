module TicTacToe
  # Creating a tictactoe game
  class GameBoard
    attr_accessor :board
    def initialize
      @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      @run = true
    end  

    def show_board
      i = 0
      3.times do
        puts @board[i].to_s + ' ' + @board[i+1].to_s + ' ' + @board[i+2].to_s
        i += 3
      end
    end

    def taken?(turn, position)
      if @board.include? (position)
        @board.map! do |element|
          if element == position
            element = turn
          else
            element
          end
        end
      else
        puts 'Cant make move there!, pick again'
        turn == 'X' ? turn_x : turn_o
      end
    end

    def turn?(turn)
      show_board
      puts "Enter a valid spot (1-9) to place your #{turn}."
      position = gets.chomp.to_i
      taken?(turn, position)
      game_result(turn)
    end

    def turn_x
      turn?('X')
    end

    def turn_o
      turn?('O')
    end

    def winner
      result = false
      i = 0
      j = 0
      #horizontal winner
      3.times do
        if @board[i] == @board[i+1] && @board[i] == @board[i+2]
          result = true
        end
        i += 3
      end
      #vertical winner
      3.times do
        if @board[j] == @board[j+3] && @board[j] == @board[j+6]
          result = true
        end
        j += 1
      end
      #diagonal winner
      if @board[0] == @board[4] && @board[0] == @board[8]
        result = true
      elsif @board[6] == @board[4] && @board[6] == @board[2]
        result = true
      end
      result
    end

    def tie
      board.all? { |matrix| matrix.is_a? String}
    end


    def game_result(turn)
      if winner
        show_board
        puts "Game Over! Winner! #{turn}"
        @run = false
      elsif tie
        show_board
        puts 'There has been a Tie!'
        @run = false
      end
    end

    def win_diagonal(turn)
      if @board[0].is_a? Fixnum
        @board[0] = turn
        turn_over = true
      elsif @board[2].is_a? Fixnum
        @board[2] = turn
        turn_over = true
      elsif @board[6].is_a? Fixnum
        @board[6] = turn
        turn_over = true
      elsif @board[8].is_a? Fixnum
        @board[8] = turn
        turn_over = true
      end
      turn_over
    end

    def win_side(turn)
      if @board[1].is_a? Fixnum
        @board[1] = turn
        turn_over = true
      elsif @board[7].is_a? Fixnum
        @board[7] = turn
        turn_over = true
      elsif @board[3].is_a? Fixnum
        @board[3] = turn
        turn_over = true
      elsif @board[5].is_a? Fixnum
        @board[5] = turn
        turn_over = true
      end
      turn_over
    end

    def artificial(turn, vs)
      turn_over = false
      i = 0
      # try to win with 1 move
      while i < 9
        original_element = @board[i]
        @board[i] = turn unless @board[i] == vs
        if winner
          turn_over = true
          i = 9
        else
          @board[i] = original_element
          i += 1
        end
      end
   
      # avoid other player to win
      unless turn_over
        i = 0
        while i < 9
          original_element = @board[i]
          @board[i] = vs unless @board[i] == turn
          # puts original_element
          if winner
            @board[i] = turn
            turn_over = true
            i = 9
          else
            @board[i] = original_element
            i += 1
          end
        end
      end

      unless turn_over
        unless @board[4].is_a? String
          @board[4] = turn
          turn_over = true
        end
      end

      unless turn_over
        if @board[4] == turn
          win_side(turn) || win_diagonal(turn)
        else
          win_diagonal(turn) || win_side(turn)
        end
      end
      game_result(turn)
    end

    def p_vs_p
      puts 'Press 1 for X(player) to take first move or 2 for O(AI) to take
            first move'
      firts_move = gets.chomp
      if firts_move == '1'
        while @run
          turn_x
          break unless @run == true
          turn_o
        end
      elsif firts_move == '2'
        while @run
          turn_o
          break unless @run == true
          turn_x
        end
      end
    end

    def p_vs_ai
      puts 'Press 1 for X(player) to take first move or 2 for O(AI) to take
            first move'
      firts_move = gets.chomp
      if firts_move == '1'
        while @run
          turn_x
          break unless @run == true
          artificial('O', 'X')
        end
      elsif firts_move == '2'
        while @run
          artificial('O', 'X')
          break unless @run == true
          turn_x
        end
      end
    end

    def ai_vs_ai
      puts 'Press 1 for X(AI) to take first move or 2 for O(AI) to take
            first move'
      firts_move = gets.chomp
      if firts_move == '1'
        while @run
          artificial('X', 'O')
          break unless @run == true
          artificial('O', 'X')
        end
      elsif firts_move == '2'
        while @run
          artificial('O', 'X')
          break unless @run == true
          artificial('X', 'O')
        end
      end
    end
  end
end

include TicTacToe
playing = true
while playing
  round = GameBoard.new
  puts 'Wanna play a game??? Press:'
  puts 'Press 1 to play VS another player'
  puts 'Press 2 to play VS AI'
  puts 'Press 3 to see AI VS AI'
  game_type = gets.chomp
  round.p_vs_p if game_type == '1'
  round.p_vs_ai if game_type == '2'
  round.ai_vs_ai if game_type == '3'
  puts 'Rematch??? Press Y... Scared of lossing anything else'
  replay = gets.chomp.upcase
  playing = false unless replay == 'Y'
end
