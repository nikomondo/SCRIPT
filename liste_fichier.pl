#!  /usr/bin/perl

use strict; 
use feature qw(say);
use Data::Dumper;

$Data::Dumper::Indent=0;

my @fic = `ls`;
my %ficNum;

@ficNum{(0..$#fic)} = (@fic) ; 

say Dumper(\@fic);
say Dumper(\%ficNum);

foreach my $cle (0..$#fic) {
	say $cle . " :  " . $ficNum{$cle};
	}

	say "Entrez nom fichier : ";
	chomp(my $num=<>); 
 
	say `ls -la $ficNum{$num}`;
