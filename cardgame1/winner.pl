# Make someone win the game

use Test::More;

use Game;
use Player;

my $game = Game->new;

my $player1 = Player->new(name => 'Will');
my $player2 = Player->new(name => 'Jogi');

for (1..5) {
    foreach my $player ($player1, $player2) {
        $player->add_to_hand( $game->deal );
    }
}

print "Both hands are:\n";
foreach my $player ($player1, $player2) {
    print "Player: ".$player->name.":\n";
    foreach my $card (@{ $winner->hand }) {
        printf("The %s of %s\n", ucfirst($card->{name}), ucfirst($card->{suit}));
    }
    print "\n";
}

my $winner = $game->who_wins($player1, $player2);

print ("-" x 80)."\n";
print "The winner is: ".$winner->name."\n";
print "Their winning hand is:\n";
foreach my $card (@{ $winner->hand }) {
    printf("The %s of %s\n", ucfirst($card->{name}), ucfirst($card->{suit}));
}

done_testing;
