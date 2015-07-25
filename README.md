# ConnectFour
Practice of the Connect Four game

## To play
After cloning the repo, type the following to enjoy the game in the console:
```
ruby lib/connect4.rb
```
Or to test it by typing:
```
rspec spec/connect4_spec.rb
```

## Time spent

With my 3 year old son's help, it took me about 5 hours to finish, here's the breakdown:
- ~2 hr evaluating of the best way to check the winning condition
- ~1 hr make the main class of Connect4 MVP works
- ~1 hr to separate the MVP to 3 classes for board data, user interaction and game flow
- 0.5 hr of writing rspec
- 0.5 hr of writing readme

## Key decisions made
It's easy to check connect chips if all letters are stored in strings, I just need to check substring of it.  In 2D array it's easy to get horizontal or vertical slices, However the key question is how to get the diagonally connected chips efficiently.
At first, I started to write double loops to join chips in the 2D array by something like this:
```
def upper_left_slices(board)
  collections = Array.new
  board.each_index do |row_index|
    slice = String.new
    (0..row_index).each do |column_index|
      slice << board[row_index - column_index][column_index]
    end
    collections << slice
  end
  return collections
end
```
But it only collect letters from half of the board, and rotations will be required to cover entire board and the other diagonal.

Therefore, I changed my mind. To check the diagonally connected chips, I first slide the rectangular board to parallelogram, and vertically slice would be diagonally connected chips:

```
1 2 3 4
5 6 7 8
9 a b c
d e f 0

1 2 |3| 4
  5 |6| 7 8
    |9| a b c
    | | d e f 0

#The '369' is the originally diagonally connected chips.
```

## My thoughts
Overall It's a fun game, though I never played it in my life and I'd like to play it with my son now!  It's good to practice accessing nested arrays.  It's bad that it's addictive!