#!env perl

# Input: A long random password
# Output: A special string containing the password hidden in it,
#           to be retrieved by following a set of rules.
#           e.g. Going backwards, take every 3rd character.
# Background: The user has poor impulse control.
#           They password-protect some system,
#           but find themselves retrieving the password,
#           entering it and circumventing their own previous decision.
# Purpose of this program: To provide the user with a way to retrieve
#           their password that is tedious and error-prone.
#           It will be so unpleasant and take so long that their impulse
#           will fade before they have managed to retrieve the password.
# Note: After generating the special string, take a screenshot of it,
#           so that the user cannot copy & paste, and is forced to
#           tediously write the password by hand. Store the screenshot
#           inside a secure password manager system.
# Alternate low-tech solution: Just write the original password
#           on a piece of paper and keep it in hidden away in your house.

use strict;
use warnings;

#my $orig = 'ZuRjguawPS8JwD@^&6Cm6azTEm$FD8ja';
my $orig = 'dogge';

# Restrict to the most unambiguous characters for visual inspection
my @allowed_characters = qw(
    a b c d e f g h
    j k
    m n
    p q r t u v w x y z
    A B C D E F G H
    J K
    M N
    P Q R T U V W X Y Z
    2 3 4 6 7 8 9
    ! @ £ $ % ^ & * ( )
);
#print "Allowed characters: @allowed_characters\n";
my $separating_chars = 4;

my $t = time;
srand($t);

my @orig_chars = split(//,$orig);
my $div = "";
foreach my $char (reverse @orig_chars) {
    print $div . $char;
    foreach (1 .. $separating_chars) {
        print $div . c();
    }
}
print "\n";

print "To retrieve the password above, read the string backwards and take every ".($separating_chars+1)."th character\n";

# end

sub c {
    return $allowed_characters[ rand( scalar(@allowed_characters) + 1 ) ];
}
