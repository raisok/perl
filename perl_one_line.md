* **可参考博客：**[http://blog.csdn.net/carzyer/article/details/5117429](http://blog.csdn.net/carzyer/article/details/5117429)

**Perl常用命令行参数概览**
```
-e 指定字符串以作为脚本（多个字符串迭加）执行
-M/-m 和 use 模块名 一样. 如果不想引入模块的缺省值, 你可以使用 -m. -m模块名 和 use 模块名() 一样.
-I （这是一个大写i）指定目录以搜索标准位置前的模块
-w 打开警告
-c 进行语法检查但并不执行程序。
-0 （这是个零）跟一个16 进制或8进制数值，指定输入记录分隔符
-l （这个是L）跟一个16 进制或8进制数值，指定输出记录分隔符
-a 打开自动分离 (split) 模式. 空格是缺省的分离号. 输入根据分离号被分离然后放入缺省数组 @F.
-F 指定分割符 -a 使用的模式
-i 在适当的位置编辑文件
-n 使用 <> 将所有 @ARGV 参数当作文件来逐个运行
-p 和 -n 一样，但是还会打印 $_ 的内容
-00 打开段落模式
-0777 打开slurp 模式 (即可以一次把整个文件读入) , 这与把$/ 设为空字符和 undef 一样效果.
-l 单独使用，有两个效果, 第一自动 chomp 输入分隔号, 第二 把$/ 值付给 $\ ( 这样 print 的时候就会自动在末尾加 \n )
-c
这个参数编译 Perl 程序但不会真正运行它. 由此检查所有语法错误.事实上，它会执行任何BEGIN或CHECK块以及任何use指示字。
```

```
1.输出随机的8个字符串，包含0-9，a-z
perl -le 'print map { ("a".."z",0..9)[rand 36] } 1..8'
2.对某一列求和
perl -lane '$sum += $F[0]; END { print $sum }'
3.在字符串末尾加上换行符
perl -pe 's/$/\n/' file
4.去掉空行
perl -ne 'print unless /^$/'
5.在所有字符中间加一个空格
perl -lpe 's// /g'
6.打印每行的行号
perl -pe '$_ = "$. $_"'
如果含有空行，只打印非空行行号
perl -pe '$_ = "$. $_" if /./'
打印匹配到的行和行号，没有匹配到的没有行号但是会输出
perl -pe '$_ = ++$x." $_" if /regex/'
只打印匹配到的行和行号
perl -ne 'print ++$x." $_" if /regex/'
7.计算多少行
perl -lne 'END { print $. }'
perl -ne '}{print $.'
8.打印非空的行
perl -le 'print ~~grep{/./}<>'
9.打印每一行最小的值
perl -MList::Util=min -alne 'print min @F'
10.将一行id对应多个GO的结果处理成一个id对应一个go的结果
perl -lane '$a=@F;foreach$b(1..$#F){print qq{$F[0]\t$F[$b]}}'  Bn.GO >Bn_oneline.annot
11.查看测序reads碱基质量值的命令
head input.fastq | awk '{if(NR%4==0) printf("%s",$0);}' |  od -A n -t u1 | awk 'BEGIN{min=100;max=0;}{for(i=1;i<=NF;i++) {if($i>max) max=$i; if($i<min) min=$i;}}END{if(max<=74 && min<59) print "Phred+33"; else if(max>73 && min>=64) print "Phred+64"; else if(min>=59 && min<64 && max>73) print "Solexa+64"; else print "Unknown score encoding!";}'
12.统计SOAPnuke结果的碱基数据量
ls /zfssz3/ST_BIGDATA/yueyao/03.TimeTest/Rub_denovo/00.data_Filter/result/*/Basic_Statistics_of_Sequencing_Quality.txt|perl -lane '@a=split/\//,$_;open IN,$_ or die $!;while(<IN>){chmomp;@b=split/\t/,$_;if ($b[0]=~/Total number of bases/){$c=$b[2]/1024/1024;print qq{$a[-2]\t$c}}}'
13.查看统计软件运行时间
ls *_run_time.txt|perl -lane '$name=$_ ;open IN,$_ or die $!;while(<IN>){chomp;if(/^\w+/){$time=$_/60/60;print qq{$name\t$time}}}'
14.将一行id一行序列的mapper.fa文件去除重复的序列（针对mirdeep2的报错进行的处理）
perl -e 'while(<>){chomp;if(/^>/){$id=$_;}else{$seq=$_;$hash{$id}=$seq;}}foreach $b(keys %hash){print qq{$b\n$hash{$b}\n}}' mapper.fa > new.fa
15.根据id提取想要的fasta文件（来自CJ的perl oneliner）
# 批量提取fasta
perl -lne 'if($switch){if(/^>/){$flag=0;m/^>?(\S+).*?$/;$flag=1 if $need{$1};}print if $flag}else{m/^>?(\S+).*?$/;$need{$1}++}$switch=1 if eof(ARGV)' Clean.ids Unigenes.fasta
# 批量过滤fasta
perl -lne 'if($switch){if(/^>/){$flag=1;m/^>?(\S+).*?$/;$flag=0 if $need{$1};}print if $flag}else{m/^>?(\S+).*?$/;$need{$1}++}$switch=1 if eof(ARGV)' NoPlant.ids Unigenes.fasta
16.查看测序数据属于phred64还是phred33    hiseqxten的是35-75属于phred33
les FCHCNLGALXX_L8_WHEGGhnwTAAIRAAPEI-57_2.fq.gz|head -n 999 | awk '{if(NR%4==0) printf("%s",$0);}'|od -A n -t u1 -v|awk 'BEGIN{min=100;max=0;}{for(i=1;i<=NF;i++) {if($i>max) max=$i; if($i<min) min=$i;}}END{if(max<=74 && min<59) print "Phred+33";else if(max>73 && min>=64) print "Phred+64";else if(min>=59 && min<64 && max>73) print "Solexa+64";else print "Unknown score encoding";print "( " min ", " max, ")";}
17.根据一个列表id在另外一个列表中提取表达量，注意所存的哈希可能需要修改
perl -e '$gene=shift;$fpkm=shift;open LIST,$gene;while(<LIST>){chomp;$id=(split/\t/,$_)[1];$pathway=(split /\t/,$_)[0];$hash{$id}=$pathway}close LIST;open FPKM,$fpkm;while(<FPKM>){chomp;if(/^gene_id/){print qq{$_\n};}else{$gene_id=(split/\t/,$_)[0];if(exists $hash{$gene_id}){print qq{$_\n};}}}close FPKM;' RUB_4Path_genelist.txt all.gene.FPKM.changeName.xls >RUB_4Path_geneFPKM.txt
18.比较装逼的写法？和:表示if和else，一定要搭配使用}{表示统计行号
perl -lane '/^H/?next:$F[2]<=2000?print:{};}{print $.;' SRPP_REF_CPT.pic.lst
tig02285153_pilon      CUFF.23689.3    1756    2932    20254  REF
19.引用和解引用的方法，引用的好处是可以直接将一个数组当做值赋值给list，而且一个地址可以被多个变量引用
perl -le '$a=1;@b=(1,2,3);%c=('abc'=>20);$aref=\$a;$bref=\@b;$cref=\%c;print qq{first_method:\t$$aref\t@$bref\t%$ref\nsecond_method:\t${$aref}\t@{$bref}\t${$cref}{'abc'}\nthird_method:\tnull\t$bref->[0]\t$cref->{'abc'}};'
20.打印想要打印的行
perl -ne '@lines = (2,4,6);print qq/$.\t$_/if grep{$_== $.}@lines;' 05.SVDetect/test.fa
21.去掉文件里面重复的行，同时也不改变文件本身的顺序
perl -e 'while(<>){chomp;push @arr,$_;};@arr = grep { ++$hash{$_} < 2 } @arr; print join("\n",@arr);print"\n"' xxx.txt >xxx.txt2
22.生成华大有参转录组计算差异表达需要的输入文件
for i in `ls /ldfssz1/ST_BIGDATA/USER/yueyao/01.testRNAseq/02.DiffExp/choice_re_do/*.gene.fpkm.xls`;do a=`echo $i|cut -d'/' -f9|cut -d'.' -f1`;printf $a"\t"$i"\n";done
23.对mutation格式的文件进行处理
les /hwfssz1/ST_BIGDATA/USER/sunysh/Data/TCGA/Cancer_project/BRCA/TCGA-BRCA.sort.mutation|cut -f2|perl -lane '$chr=(split/:/,$_)[0];$gene=(split/:/,$_)[1];($gene=~/(\d+)(\w+>\w+)/||$gene=~/(\d+_\d+)(\w+)/||$gene=~/(\d+\w+)/)?{print qq{$chr\t$1\t$2}}:next}{'|les
24.将序列格式化为想要的一行id和多行序列,正则里面设置想要每行打印的碱基数,可能会有bug
 perl -e '$/=">";<>;while(<>){chomp;($id,$seq)=(split /\n/,$_,2)[0,1];$seq=~s/\n//g;$seq=~ s/(\w{30})/$1\n/g;print ">",$id,"\n",$seq;}' in.fa >out.fa
25.将序列由多行变成一行
perl -e '$/=">";<>;while(<>){chomp;($id,$seq)=(split/\n/,$_,2)[0,1];$seq=~s/\n//g;print ">".$id."\n".$seq."\n";}'  in.fa >out.fa
```



