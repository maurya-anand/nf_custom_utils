#!/usr/bin/env perl

#usage: perl ./bin/parse.trnascan.ss.pl tair10.filtered.ss .

use strict;
use warnings;
use Data::Dumper;

my $trnascanOut = $ARGV[0];
my $resultsDir=$ARGV[1];

my $outFile="$resultsDir/$trnascanOut.parsed.tab.txt";
open(OUT,">$outFile") or die "can't write to output file\n";

local $/ = "\n\n";
# https://stackoverflow.com/questions/16678610/grabbing-chunks-of-data-from-file-in-perl
# grabbing chunks of data

open(SS,"$trnascanOut") or die "can't open the $trnascanOut\n";
while(my $chunk=<SS>){
	chomp $chunk;
	my @chunk_rec= split(/\n/,$chunk);
	
	if (scalar @chunk_rec == 7) {
		print OUT "$chunk_rec[0]\t$chunk_rec[1]\t$chunk_rec[2] $chunk_rec[3]\t$chunk_rec[4]\t$chunk_rec[5]\t$chunk_rec[6]\n";
	}
	elsif  (scalar @chunk_rec == 5) {
		print OUT "$chunk_rec[0]\t$chunk_rec[1]\t-\t-\t$chunk_rec[2]\t$chunk_rec[3]\t$chunk_rec[4]\n";
	}
	else {
		print OUT join("\t",@chunk_rec)."\n";
	}
}

print "Output: $outFile\n";
