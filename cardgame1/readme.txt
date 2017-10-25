spec:

card game (simplified poker):
* 52 card deck is shuffled
* two players are dealt a hand of five cards each
* player with the highest value hand wins

analysis:

data structures:
* class: game (manages pack of cards, who's turn it is)
    * hash: cards (has face, and value)
* class: player (holds a hand)

pseudocode for gameplay:
start game
shuffle pack of cards
players = [1, 2]
turn = player 1
while (game isn't over)
    # initial deal
    for 1..3
        assign a card to current player
        next player
    end

    # calculate hands
    decide winner
        check for pairs, triples, straight, flush, etc.
        end game
end
