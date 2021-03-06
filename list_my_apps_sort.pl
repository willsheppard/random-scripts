#!/versions/perl-5.20.0/bin/perl

# Simple script to process the CSV file generated by the "List My Apps" android app by Onyxbits
#   and sort apps by date installed/updated. Useful if your phone starts crashing and you want
#   to uninstall the most recent apps in order, one by one, to find out which one is causing
#   the problem.
# Get the app at https://play.google.com/store/apps/details?id=de.onyxbits.listmyapps&hl=en

# Example input data format:
#   ${packagename}, ${displayname}, ${source}, ${uid}, ${version}, ${versioncode}, ${firstinstalled}, ${lastupdated}, ${datadir}, ${targetsdk}, ${tags}, ${marketid}
#   com.guywmustang.airplanewidget,Airplane Widget,https://play.google.com/store/apps/details?id=com.guywmustang.airplanewidget,10164,1.6.3,163,19 Jun 2014 17:20:39,19 Jun 2014 17:20:39,/data/data/com.guywmustang.airplanewidget, 17,,com.android.vending

use strict;
use warnings;

use DateTime::Format::Strptime;
use Data::Dumper;

my $file = $ARGV[0] || die "usage:\n$0 [file]\n";

open(my $fh,'<',$file) or die "can't open $file ($!)";
my @lines = <$fh>;
chomp(@lines);
close($fh);

my $header_line = shift @lines;
my @headers = split(',', $header_line);
chop(@headers);
#warn "headers = ".Dumper(\@headers);
@headers = map {
    s/^\s?\$\{//;
    s/\}$//;
    $_;
} @headers;
#warn "headers = ".Dumper(\@headers);

my @apps;
foreach my $line (@lines) {
    my @fields = split(',', $line);
    my %app;
    foreach my $i (0 .. scalar(@headers)-1) {
        chop($fields[$i]) if $i == scalar(@headers)-1;
        $app{ $headers[$i] } = $fields[$i];
    }
    push @apps, \%app;
}

#warn "apps = ".Dumper(\@apps);

my $parser = DateTime::Format::Strptime->new(
  pattern => '%d %b %Y %H:%M:%S',
  on_error => 'croak',
);
my $sort_field = 'firstinstalled'; # try 'lastupdated' too
#my $sort_field = 'lastupdated';
my @sorted_apps = sort {
    DateTime->compare(
        $parser->parse_datetime( $a->{$sort_field} ),
        $parser->parse_datetime( $b->{$sort_field} )
    )
} @apps;

#warn "sorted apps = ".Dumper(\@sorted_apps);

print "$sort_field\tdisplayname\tversion\n";
foreach my $app (@sorted_apps) {
    print "$app->{$sort_field}\t$app->{displayname}\t$app->{version}\n";
}
