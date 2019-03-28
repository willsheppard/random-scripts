#!/usr/bin/env perl -l

# Calculator/wizard for https://xkcd.com/1205/

use strict;
use warnings;

use lib 'local/lib/perl5';

use Term::Choose qw( choose );

my @how_often_choices = qw(
    50/day
    5/day
    Daily
    Weekly
    Monthly
    Yearly
);
print "How often do you do the task?";
my $how_often = choose( \@how_often_choices );

my @how_much_time_choices = (
    '1 second',
    '5 seconds',
    '30 seconds',
    '1 minute',
    '5 minutes',
    '30 minutes',
    '1 hour',
    '6 hours',
    '1 day',
);
print "How much time will you shave off?";
my $how_much_time = choose ( \@how_much_time_choices );

my $how_long = calculate_how_long($how_often, $how_much_time);

print "You can spend $how_long making this routine task more efficient";
print "before you're spending more time than you save (across five years)";

exit;

# Functions

sub calculate_how_long {
    my ($often, $long) = @_;
    die "not implemented" unless $often eq 'Weekly' && $long eq '5 minutes';

    my $years = 5;
    my $spend_secs = 60 * 5;
    my $total_spend_secs = $spend_secs * 52 * $years;
    my $total_spend_hours = $total_spend_secs / 60 / 60;

    return sprintf("%.0f hours", $total_spend_hours);
}

