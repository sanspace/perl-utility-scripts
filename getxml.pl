#!/usr/bin/perl
# XML Extractor
# This script reads the given log files line by line
# and produces output with the XMLs found

use strict;
use warnings;
use constant {
   # just a personal preference for boolean
   true => 1,
   false => 0
};

sub help {
print <<HEREDOC;
#####################################################################
                  getxml - XML Extractor

If you have a file full of xmls and other stuff (typically logs),
getxml script can help you get the XML lines alone.

Usage: getxml root-tag-name input-file

For instance, to extract below XML file

<start><item><itemno>1</itemno><name>foo</name><item></start>

getxml start /your/log/file.log

You can also redirect the output to a file to save XMLs.

getxml start /your/log/file.log > xmls.out

#####################################################################
HEREDOC
}

sub croak { die "$0: @_: $!\n" } # error handling

sub process_file {
    my $tag = shift;
    my $file = shift;
    my $match = false;
    my $xml = '';
    open FILE, $file or croak("Failed opening $file");
    while (my $line = <FILE>) { # each line of file
        if ($line =~ m/<$tag>/) { # if <tag> presents in a line
            if (!$match) { # If we're not in the middle of another match

               $match = true; # We've got a starting match
            } else { # We're already in the middle of another match

               # It's a mismatch; Once <tag> is found,
               # there should be a </tag> before next <tag>
               # We'll have to discard this one and proceed further.
               $xml = ''; # Empty the temp variable
               $match = false; # reset matching

               # We're suppressing the mismatch for now
               # TODO: Report list of mismatched XMLs
            }
        }
        if ($match) { # We're in the middle of a match
            # removes unnecessary line breaks; chomp isn't platform friendly
            $line =~ s/\r?\n$//; 
            $xml .= $line; # Add found XML to the temp variable
        }
        if ($line =~ m/<\/$tag>/) { # if </create> presents in a line

            if (!$match) { # If we're not in the middle of a match

               # It's a mismatch too; When a </tag> is found,
               # there should have been a <tag> matched earlier
               # We'll have to discard this one and proceed further.

               # We're suppressing the mismatch for now
               # TODO: Report list of mismatched XMLs
            } else { # We're in the middle of a match

               # We're done with a XML.
               print "$xml\n"; # Output the whole XML found
            }

            # At this point we have a match or a mismatch
            # Either case, we need to reset the match
            # Reset the match so we can look for another
            $xml = ''; # Empty the temp variable
            $match = false; # reset matching
        }
     }
     close FILE or croak("Failed closing $file");
}

sub cat {
    my $tag = shift || 'h';

    # Display help info if no input was supplied
    if ($tag eq 'h') {

      help;
      exit;
    }

    while (my $file = shift) { # each file received from command line

        process_file($tag, $file);
    }
}
cat @ARGV;
