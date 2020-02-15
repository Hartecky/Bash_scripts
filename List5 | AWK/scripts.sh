#!/bin/bash

#Coding Lab | Exercises nr 5
#Files with data are in the Variant Call Format
#Task 1

NeomysA='Neomys_fodiens_A.txt'
NeomysB='Neomys_fodiens_B.txt'

echo 'AWK scripts coding_lab exercises | List 5' >> result.txt

# a) All SNPs
awk 'BEGIN {print "SNPs in both organisms: "}
	END {print NR}' $NeomysA $NeomysB >> result.txt

# b) Difference of SNPs
echo 'Difference of SNPs value in both organisms' >> result.txt
echo 'First: ' >> result.txt
	SNP_A=$(awk 'END {print NR}' Neomys_fodiens_A.txt) 
	echo $SNP_A >> result.txt

echo 'Second: ' >> result.txt
	SNP_B=$(awk 'END {print NR}' Neomys_fodiens_B.txt) >> result.txt
	echo $SNP_B >> result.txt

echo 'The difference' >> result.txt
	SNP_subtr="$((SNP_A - SNP_B))"
	echo $SNP_subtr >> result.txt

# c) Replacement of Adenine

awk 'BEGIN {print "Number of adenine replacements"}{RS="Chr"}{if ($4=="A") {count++}} END {print count}' $NeomysA >> result.txt
awk 'BEGIN {RS="Chr"}{if ($4=="A") {count++}} END {print count}' $NeomysB >> result.txt


# d) Print the same SNPs in both organisms 
echo "The same SNPs in both organisms is located in a roz.txt file" >> result.txt
awk 'FNR==NR {a[$1];next}$1 in a {print $0}' $NeomysA $NeomysB > roz.txt

#Task 2
# a) Length of a duplicated sequences
	# 1) By the length of a sequence
	echo "Length of a duplicated sequence" >> result.txt
	awk 'NR%2==0 {print length}' duplikacje.Btaurus.txt >> result.txt

	# 2) By the header 
	echo "Length v2" >> result.txt
	awk '/:/ {print}' duplikacje.Btaurus.txt > indeksy.txt 
	awk -F '[:-]' '{print $1" "$2" "$3} {print $3-$2}' indeksy.txt >> result.txt