package Player;

=head1 NAME

Player

=head1 DESCRIPTION

Player for a card game, for programming practice.

=cut

use Moose;

has hand => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has hand_count_maximum => (
    is => 'ro',
    isa => 'Int',
    default => sub { 5 },
);

has name => (
    is => 'ro',
    isa => 'Str',
);

sub BUILD {
    my ($self) = @_;
}

sub add_to_hand {
    my ($self, $card) = @_;
    die "hand is already full" if scalar( @{ $self->hand } ) == $self->hand_count_maximum;
    push @{ $self->hand }, $card;
    return;
}

1;
