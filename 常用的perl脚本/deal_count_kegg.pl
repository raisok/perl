#!/usr/bin/perl 

#这个脚本用于根据所有基因的kegg的注释结果，寻找差异表达基因在kegg注释结果目录分类中的个数


die "Usage: perl $0 gene.lst kegg.xls >dge_kegg.lst\n" if (@ARGV ==0 );
$gene_id=shift;
$kegg=shift;


my$id;
my%hash;

open IN,$gene_id or die $!;
$id = <IN>;
while(<IN>){
	$_=~s/\r\n//g;
	$hash{$_} =1;
}
close IN;


my@arr;
my@gene;
my$temp;
my$m;
my$count;

open KEGG,$kegg or die $!;
$id=<KEGG>;

while(<KEGG>){
	chomp;
	$kegg_an = (split /\t/,$_)[0];
	$temp=(split /\t/,$_)[3];
	@gene = split /;/,$temp;
	$count=0;
	foreach $m (@gene){
		if(exists $hash{$m}){
			$count++;
		}
	}
	print "$kegg_an\t$count\n";
}
close KEGG;