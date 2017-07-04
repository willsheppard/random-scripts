#!/usr/bin/perl

=head1 NAME

dark_room.pl

=head1 SYNOPSIS

dark_room.pl [product] [amount] [time] [[amount] [time]] [...]

=head1 DESCRIPTION

A tool to help make calculations for A Dark Room game for Android.

Parameters:

   * product - name of item being produced (optional)
   * amount  - how much is being produced/used. Number can be positive/negative.
   * time    - how long does it take to produce that amount (s)

There can be any number of amount & time pairs.

Example:

    e.g. dark_room.pl fur 8.5 30 -10 80

=cut

use strict;
use warnings;

use Data::Dumper;

die "usage: $0 [product] [amount] [time] [[amount] [time]] [...]\n"
    unless scalar @ARGV;

my $dark = Game::Idle::DarkRoom->new(@ARGV);

$dark->calculate;

exit;


package Game::Idle::DarkRoom;

sub new {
    my ($class, @args) = @_;
    my $product = shift @args if $args[0] =~ m/[^\d\.\-]/;
    die "expected even number of arguments"
         unless (@args % 2) == 0;
    my $self = {};
    bless $self, $class;
    my $input = $self->preprocess( @args );
    $self->{input} = $input;
    $self->{product} = $product // "";
    return $self;
}

sub preprocess {
    my ($self, @args) = @_;

    my @data;
    my $count = 1;
    for (my $i = 0; $i < scalar(@args); $i += 2) {
        push @data, {
            amount => $args[$i],
            time   => $args[$i+1],
            index  => $count++,
        };
    }
    return \@data;
}

sub calculate {
    my ($self) = @_;

    # get overall gain/loss
    my $total_amount = 0;
    foreach my $item (@{ $self->{input} }) {
        my @other_times = map {
            $_->{time}
        } grep {
            $_->{index} != $item->{index}
        } @{ $self->{input} };
        my $total_other_time = 1;
        foreach my $time (@other_times) {
            $total_other_time *= $time;
        }
        $total_amount += $item->{amount} * $total_other_time;
    }

    my $long_time = 1;
    $long_time *= $_ for map { $_->{time} } @{ $self->{input} };

    my $message;
    if ($total_amount > 0) {
        $message = "you will gain";
    } elsif ($total_amount < 0) {
        $message = "you will lose"
    } else {
        $message = "you will break even";
        print "$message with 0 " . $self->{product} . "\n";
        return;
    }

#    print "$message $total_amount"
#        . " over $long_time seconds\n";

    # reduce numbers
    my $reduced_amount = 1;
    my $reduced_time = $long_time / $total_amount;
    $reduced_time *= -1 if $reduced_time < 0;

    printf("$message $reduced_amount "
        . $self->{product}
        . " in %d seconds\n", $reduced_time);
}

1;
