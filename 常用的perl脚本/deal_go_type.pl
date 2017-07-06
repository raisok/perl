#!/usr/bin/perl -w
use strict;

die "Usage: perl $0 go.annot >new_go.annot \n" if (@ARGV == 0);
#这个脚本用于将一个id对应多个go的结果转换成一行id对应一个go的结果

my$id;
my@arr;
my$go;

open IN,$ARGV[0] or die $!;
while(<IN>){
	chomp;
	@arr=split;
	$id = $arr[0];
	foreach $go(@arr){
		if($go =~ /GO/){
			print	"$id\t$go\n";
		}
	}
}
close IN;