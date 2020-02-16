#!/bin/bash
#Coding Lab | Ex nr 6
#Files with data are in the Copy Number Varation format
#Task1

#Files with data
bt1="bt00001.txt"
bt2="bt00002.txt"
echo "#####		CNV 	#####" >> result.txt
echo "---  ---  ---" >> result.txt
# a) Amount of all CNVs
echo "All CNVs: " >> result.txt
awk 'END {print NR}' $bt1 $bt2 >> result.txt


#b ) Deletions and duplications 

# AWK way
#awk '/deletion/ {count++} BEGIN {print "Liczba delecji"} END {print count "	(awk)"}' bt0000*.txt

# Bash way
echo "----	----  ----" >> result.txt
let del=0
for row in $(cat $bt1 $bt2)
do
	if [ $row == 'deletion' ]
	then 
		let 'del++'
	fi
done

echo "All deletions: " $del >> result.txt

#Awk way
#awk '/duplication/ {count++} BEGIN {print "Liczba duplikacji"} END {print count "	(awk)"}' bt0000*.txt

#Bash way
echo "----	----  ----" >> result.txt
let dupl=0
for row in $(cat $bt1 $bt2)
do
	if [ $row == 'duplication' ]
	then 
		let 'dupl++'
	fi
done

echo "All duplications: " $dupl >> result.txt

# c) Deletions & duplications on 3rd chromosome

#dels
echo "----	----  ----" >> result.txt
let chrom_3del=0
for row in $(grep "chr3" $bt1) $(grep "chr3" $bt2)
do
	if [ $row == 'deletion' ]
	then
		let 'chrom_3del++'
	fi
done

echo "Deletions on 3rd chromosome: "$chrom_3del >> result.txt

#dupls
echo "----	----	----" >> result.txt
let chrom_3dup=0
for row in $(grep "chr3" $bt1) $(grep "chr3" $bt2)
do
	if [ $row == 'duplication' ]
	then
		let 'chrom_3dup++'
	fi
done

echo "Duplications on 3rd chromosome: " $chrom_3dup >> result.txt

# d) Percentage value of duplications
echo "----	----  ----" >> result.txt
counts=$(cat $bt1 $bt2 | wc -l)
perc_duplications=$(echo "scale=2; $dupl*100/$counts" | bc)
echo "Percentage value of duplications: " $perc_duplications >> result.txt

# e) Mean length of all polymorphisms
echo "----	----  ----" >> result.txt
let polim_len=0 
for row in $(cat $bt1 $bt2 | cut -f 3)
do 
	let polim_len+=row
done 
mean_polim_len=$(echo "scale=2; $polim_len/$counts" | bc)
echo "Mean polymorphism length: " $mean_polim_len >> result.txt


# f) Mean length of duplication
echo "----	----	----" >> result.txt
let dupl_len=0
for row in $(grep "duplication" $bt1 | cut -f 3) $(grep "duplication" $bt2 | cut -f 3)
do
	let dupl_len+=row
done

mean_dupl_len=$(echo "scale=2; $dupl_len/$dupl" | bc)
echo "Mean duplication length: " $mean_dupl_len >> result.txt

# g) The longest duplication
echo "----	----  ----" >> result.txt
echo "The longest duplication: " >> result.txt
awk '/duplication/ {if($3>max){want=$3; max=$3}}END{print want}' $bt1 $bt2 >> result.txt
echo "---- ---- ----" >> result.txt
echo "The longest deletion" >> result.txt
awk '/deletion/ {if($3>max){want=$3; max=$3}}END{print want}' $bt1 $bt2 >> result.txt

# h) The shortest deletion
echo "----	----	----" >> result.txt
echo "The shortest deletion" >> result.txt
awk 'min=="" || $3 < min {min=$3}; END{ print min}' $bt1 $bt2 >> result.txt


#Task3
#Duplications in both organisms, the same way for deletions
echo "----	----	----" >> result.txt
echo "Duplications which are in both organisms are in the same_dupl.txt file"  >> result.txt
awk 'FILENAME=="bt00001.txt"{A[$1$2$3]=$1$2$3} FILENAME=="bt00002.txt"{if(A[$1$2$3]){print}}' $bt1 $bt2 > same_dupl.txt