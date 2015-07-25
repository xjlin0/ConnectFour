require 'connect4'

describe Connect4 do

  chips = {"Red" => "Red rocks!", "Yellow" => "Winner is Yellow!"}
  configs = {column: 5, row: 4, win: 3, chips: chips}
  connect4 = Connect4.new(configs)
  connect4.deposit_at(column: 2, symbol:'R')

  describe '#deposit_at' do
    it 'deposit chips and pile up' do
      expect(connect4.board[2][2]).to be nil
      connect4.deposit_at(column: 2, symbol:'R')
      expect(connect4.board[2][2]).to eq('R')
    end
  end

  describe '#check_winner' do
    it 'check the adjacent chips for winner' do
      expect(connect4.check_winner).to be nil
      connect4.board[2][1] = 'R'
      connect4.board[1][0] = 'R'
      expect(connect4.check_winner).not_to be nil
    end
  end
end