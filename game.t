# Tests for "Game"

use Test::More;

use_ok('Game');

my $game = Game->new;

my $expected_deck_count = 52;
is( scalar(@{ $game->deck }), $expected_deck_count, "$expected_deck_count cards in the deck" );

my $card = $game->deal;

my @card_fields = sort keys %$card;
is_deeply( \@card_fields, [sort qw/suit name value/], "Dealt a valid card" );
is( scalar(@{ $game->deck }), $expected_deck_count - 1, ($expected_deck_count - 1)." cards in the deck" );

done_testing;
