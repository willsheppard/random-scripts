# Tests for "Game"

use Test::More;
use Test::Exception;

# Game

use_ok('Game');

my $game = Game->new;
isa_ok($game, 'Game');

my $expected_deck_count = 52;
is(scalar(@{ $game->deck }), $expected_deck_count, "$expected_deck_count cards in the deck");

my $card = $game->deal;

my @card_fields = sort keys %$card;
is_deeply( \@card_fields, [sort qw/suit name value/], "Dealt a valid card" );
is(scalar(@{ $game->deck }), $expected_deck_count - 1, ($expected_deck_count - 1)." cards in the deck");

# Players

use_ok('Player');

my $player1 = Player->new(name => 'Will');
isa_ok($player1, 'Player');
is($player1->name, 'Will', 'Name is correct');

is_deeply($player1->hand, [], 'Empty hand');
my $card2 = $game->deal;
$player1->add_to_hand( $card2 );
is_deeply($player1->hand, [ $card2 ], 'Hand contains card');

for my $i (1..4) { $player1->add_to_hand( 'fake_card' ) }
throws_ok( sub { $player1->add_to_hand( 'one_card_too_many' ) }, qr/already full/, "Dies after maximum card limit" );

# Winner

my $player_a = Player->new(name => 'Bob');
my $card_a = $game->deal;
note sprintf("%s is dealt the %s of %s\n", $player_a->name, ucfirst($card_a->{name}), ucfirst($card_a->{suit}));
$player_a->add_to_hand($card_a);

my $player_b = Player->new(name => 'Mary');
my $card_b = $game->deal;
note sprintf("%s is dealt the %s of %s\n", $player_b->name, ucfirst($card_b->{name}), ucfirst($card_b->{suit}));
$player_b->add_to_hand($card_b);

my $winner = $game->who_wins($player_a, $player_b);

if ($winner) {
    ok($winner->name, 'A winner was chosen: '.$winner->name);
    note("The winning hand was:");
    foreach my $card (@{ $winner->hand }) {
        note sprintf("The %s of %s\n", ucfirst($card->{name}), ucfirst($card->{suit}));
    }
}
else {
    note("The game was a draw");
}

done_testing;
