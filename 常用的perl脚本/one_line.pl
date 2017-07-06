#!/usr/bin/perl -w
use strict;
my $genome = shift;
open IN, "< $genome" or die $!;
$/ = ">"; <IN>; $/ = "\n";
while(<IN>){
        chomp;
        my $header = (split /\s+/, $_)[0];
        print ">$header\n";
        $/ = ">";
        my $seq = <IN>;
        $seq =~ s/\s+//g;
        $seq =~ s/>//g;
        print "$seq\n";
        $/ = "\n";
}
close IN;