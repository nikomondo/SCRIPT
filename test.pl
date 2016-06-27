#!/usr/bin/perl -w 
use strict ;
use feature qw(say);
use warnings;
use Data::Dumper; 

$Data::Dumper::Indent=0;

my @number=(1..20); 

my @pair = grep {! ( $_ % 3) } @number;

 say join ' ',@pair;

