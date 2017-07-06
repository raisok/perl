#!/usr/bin/perl -w
use strict;

#这个脚本用于处理kegg的ko文件，生成基因id对应的ko编号
die "Usage : perl $0 All-Unigene.fa.ko >geneid_ko.lst\n" if (@ARGV == 0);


my $kofile = shift;
my $temp;
my @temp;
my $ko;



open IN,$kofile or die $!;
while(<IN>){
	chomp;
	next if ($_ eq "" or index($_, "#") == 0);
	@temp = split /\t/, $_;
	next if (@temp < 2 || $temp[1] =~ /^\s*$/);
	for $ko (split /!+/, $temp[1]) {
		$ko = (split /\|+/, $ko)[0];
		print $temp[0]."\t".$ko."\n";
	}
}

close IN;
