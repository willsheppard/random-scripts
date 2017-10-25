package Game;

=head1 NAME

Game

=head1 DESCRIPTION

Simplified poker game, for programming practice.

=cut

use Moose;
use List::Util 'shuffle';

has deck => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has _card_name => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { [ qw/ace two three four five six seven eight nine ten jack queen king/ ] },
);

sub BUILD {
    my ($self) = @_;

    # create deck
    foreach my $suit (qw/hearts diamonds clubs spades/) {
        for my $value (1 .. 13) {
            my %card = (
                suit => $suit,
                name => (@{$self->_card_name})[$value - 1],
                value => $value,
            );
            push @{ $self->deck }, \%card;
        }
    }

    # shuffle cards
    $self->shuffle_deck;
}

sub shuffle_deck {
    my ($self) = @_;
    my @shuffled = shuffle @{ $self->deck };
    $self->deck(\@shuffled);
}

sub deal {
    my ($self) = @_;
    return pop( @{ $self->deck } );
}

sub who_wins {
    my ($self, $player1, $player2) = @_;
    my $hand_1_value = 0;
    foreach my $card (@{ $player1->hand }) {
        $hand_1_value += $card->{value};
    }
    my $hand_2_value = 0;
    foreach my $card (@{ $player2->hand }) {
        $hand_2_value += $card->{value};
    }
    return $player1 if $hand_1_value > $hand_2_value;
    return $player2 if $hand_2_value > $hand_1_value;
    return undef; # it's a draw
}

1;
