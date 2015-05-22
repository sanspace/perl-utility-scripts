#!/usr/bin/env perl
use strict;
use warnings;

# For testing / debugging
# sub print_arr {
    # print "Printing array";
    # for my $elem (@{$_[0]}) {
        # print $elem;
    # }
# }

my ($fish_file, $sea_file) = @ARGV;

open FFH, '<', $fish_file or die "Couldn't open $fish_file";
my @fishes = <FFH>; # Load fishfile into @fishes array
close FFH;

open SFH, '<', $sea_file or die "Couldn't open $sea_file";
my @sea = <SFH>; # Load seafile into @sea array
close SFH;

# Remove empty or lines with whitespaces from @fishes
@fishes = grep /\S/, @fishes;
# Loop through fishes for each fish
for my $fish (@fishes) {
    # Let's go fishing in the sea!
    @sea = grep !/$fish/, @sea;
}

# Open seafile file to print the results
open SFH, '>', $sea_file or die "Couldn't open $sea_file";
print SFH @sea;
close SFH;

# LIMITATIONS
# Not sure if it handles large files