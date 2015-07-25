class Connect4
  attr_accessor :board

  def initialize(options={})
    @column = options.fetch(:column){ 7 }
    @row    = options.fetch(:row)   { 6 }
    @win    = options.fetch(:win)   { 4 }
    @chips  = options.fetch(:chips)
    @board  = Array.new(@row) {Array.new(@column, nil)}
    @instruction  = "Where to drop the chip? (enter any invalid data to forfeit or q to quit)"
  end

  def render(options={})
    clear_screen = "\e[2J\e[H"
    message      = options.fetch(:message) { @instruction }
    puts (1..@column).inject(clear_screen){|header, column| header << "%2d" % column + "|"}
    puts seperator = "-" + "-+-"*@column
    @board.each do |row|
      row.each{ |cell| print "%2s" % cell + "|" }
      puts "\n" + seperator
    end
    puts message
  end

  def check_winner
    rows      = slices
    columns   = slices(column: true)
    slided
    diagonal1 = slices(diagonal: true)
    slided(reverse: true)
    diagonal2 = slices(diagonal: true)
    slices    = rows + columns + diagonal1 + diagonal2
    @chips.each do |chip_color, win_message|
      return win_message if slices.any?{ |slice| slice.include?(chip_color[0]*@win) }
    end
    nil
  end

  #deposit_at make the chips fall to lowest empty spot in a specified column
  def deposit_at(options={})
    column    = options.fetch(:column)
    symbol    = options.fetch(:symbol)
    occupied  = @board.transpose[column].join
    empty_row = @row - occupied.length - 1
    @board[empty_row][column] = symbol if empty_row > -1 && column > -1
  end

  private

  #slices return hirizontal, vertical or diagonal slices of the board
  def slices(options={})
    diagonal = options.fetch(:diagonal) { false }
    column   = options.fetch(:column)   { false }
    board    = diagonal ? @parallelogram.transpose : @board
    board    = board.transpose if column
    ( 0..board.length-1 ).map{ |row| board[row].join }
  end

  #slided transform the board into a parallelogram for getting diagonal slices later
  def slided(options={})
    reverse = options.fetch(:reverse) { false }
    parallelogram = Marshal.load(Marshal.dump(@board))
    spacers = 0..board.length - 1
    spacers = spacers.to_a.reverse if reverse
    spacers.each_with_index do |spacer, index|
      spacer.times{ parallelogram[index].unshift(nil) }
      (board.length - 1 - spacer).times{ parallelogram[index].push(nil) }
    end
    @parallelogram = parallelogram
  end
end

class Interface
  def initialize(options={})
    @chips   = options.fetch(:chips)
    @welcome = "Welcome to play Jack's connect four, please set the board size:"
    @question= "[Please enter a positive integer] How many %{unit} ?"
    @prompt  = "Please enter the column number (1~%{column}) for %{current_color} chip:"
  end

  def get_board_parameters
    puts @welcome, @question % {unit: 'columns (default: 7)'}
    column = gets.chomp.to_i
    column = column.zero? ? 7 : column
    puts @question % {unit: 'rows (default: 6)'}
    row = gets.chomp.to_i
    row = row.zero? ? 6 : row
    puts @question % {unit: 'adjacent chips to win (default: 4)'}
    win = gets.chomp.to_i
    win = win.zero? ? 4 : win
    {column: column, row: row, win: win, chips: @chips}
  end

  def get_users_keys(options={})
    round  = options.fetch(:round)
    column = options.fetch(:column)
    current_color  = @chips.keys[round % @chips.length]
    current_symbol = current_color[0]
    puts @prompt % {column: column, current_color: current_color}
    user_input = gets.chomp.to_i while !user_input || !user_input.between?(0, column)
    {column: user_input - 1, symbol: current_symbol}
  end
end

class Game
  def initialize(options={})
    @chips = options.fetch(:chips) {{"Red" => "Red rocks!", "Yellow" => "Winner is Yellow!"}}
    @round = -1
  end

  def play
    interface     = Interface.new(chips: @chips)
    customization = interface.get_board_parameters
    connect4      = Connect4.new(customization)
    winner        = nil
    user_inputs   = Hash.new
    until user_inputs[:column] == -1 || winner
      @round     += 1
      connect4.render
      user_inputs = interface.get_users_keys(column: customization[:column], round: @round)
      connect4.deposit_at(user_inputs)
      winner      = connect4.check_winner
    end
    connect4.render
    puts winner
  end
end

game = Game.new
game.play
