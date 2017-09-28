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

1;
