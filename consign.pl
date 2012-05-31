use strict;
use warnings;
sub croak { die "$0: @_: $!\n" }

sub print_file {
    my $file = shift;
    open FILE, $file;
    while (my $line = <FILE>) {
        if ($line =~ m/\b[A-Z]\d{8}/) {
            $line =~ s/\r?\n$//; # removes EOL; chomp does not have cross-platform support for EOL
            $file =~ s/\.TXT$//; # to remove extension from the file name
            print "$line     $file\n";
        }
    }
}

sub cat {
    while (my $file = shift) {
        print_file $file;
    }
}
cat @ARGV;
