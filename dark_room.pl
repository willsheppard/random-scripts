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

my $batch; # default: off

die "usage: $0 [product] [amount] [time] [[amount] [time]] [...] [batch]\n"
    unless scalar @ARGV;

my $dark = Game::Idle::DarkRoom->new(@ARGV);

$dark->calculate;

exit;


package Game::Idle::DarkRoom;

use constant DATA_FILE => "dark_room.data";

sub new {
    my ($class, @args) = @_;
    my @orig_args = @args;

    # optionally fetch product name from first argument
    my $product = shift @args if $args[0] =~ m/[^\d\.\-]/;

    # optionally fetch "batch" flag from last argument
    my $batch = pop @args if $args[-1] =~ m/[^\d\.\-]/;

    die "expected even number of arguments"
         unless (@args % 2) == 0;
    my $self = {};
    bless $self, $class;
    my $input = $self->preprocess( @args );
    $self->{input} = $input;
    $self->{batch} = $batch;
    $self->{product} = $product // "";
    $self->{args} = \@orig_args;
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

    # log input arguments
    $self->log_input_args;

    # calculate gain or loss
    # for batch of previous products

    # calculate gain or loss
    # for specified product
    my ($delta, $amount, $time) = $self->delta;

    $self->display_output(
        $delta, $amount, $time
    );
}

sub display_output {
    my ($self, $delta, $amount, $time) = @_;

    # prepare output
    my $message;
    if ($delta > 0) {
        $message = "you will gain";
    } elsif ($delta < 0) {
        $message = "you will lose"
    } else {
        # stop here if breaking even
        $message = "you will break even";
        $self->output_message("$message with 0 " . $self->{product});
        return;
    }

    # display gain or loss message
    $self->output_message( "$message $amount " . $self->{product} . " in $time seconds" );
}

sub delta {
    my ($self) = @_;

    # calculate overall gain or loss
    my $total_delta = 0;
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
        $total_delta += $item->{amount} * $total_other_time;
    }

    return ($total_delta, undef) if $total_delta == 0; # if breaking even, time is irrelevant

    # reduce numbers so they're easy to understand
    my $long_time = 1;
    $long_time *= $_ for map { $_->{time} } @{ $self->{input} };
    my $reduced_time = $long_time / $total_delta;
    $reduced_time *= -1 if $reduced_time < 0; # time is always positive

    if ($reduced_time != 0 && $reduced_time > -1 && $reduced_time < 1) {
        # explain small values
        $reduced_time = '< 1';
    }
    else {
        # format as an integer
        $reduced_time = sprintf("%d", $reduced_time);
    }

    my $reduced_amount = 1; # this doesn't change
    return ($total_delta, $reduced_amount, $reduced_time);
}

sub log_input_args {
    my ($self) = @_;
    $self->log_message("# ".`date`); # includes \n
    $self->log_message("perl $0 ".join(" ", @{ $self->{args} })."\n");
}

sub output_message {
    my ($self, $message) = @_;
    print "$message\n";
    $self->log_message("$message\n");
}

sub log_message {
    my ($self, $message) = @_;
    open(my $fh, '>>', &DATA_FILE) or die "Can't open ".&DATA_FILE.": $!";
    print $fh $message;
    close($fh) or die "Can't close ".&DATA_FILE.": $!";
}

1;
