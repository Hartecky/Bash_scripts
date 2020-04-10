#!/bin/bash
#  Liczba wszystkich rekordów w pliku
vep='drosophila.vep'

echo "Liczba wszystkich rekordów: "
awk 'END {print NR}' $vep

# Na jak wiele genów będą miały wpływ analizowane polimorfizmy ?
 
genes=  awk -F '\t' '/FBgn/ {print $4}' $vep | sort | uniq -c | sort -nr > genes.txt
genes_file=$(cat genes.txt | wc -l)

echo "Liczba genów, na które będą miały wpływ polimorfizmy: " $genes_file

transcripts=  awk -F '\t' '/FBtr/{print $5}' $vep | sort | uniq -c | sort -nr > transcripts.txt
transcripts_file=$(cat transcripts.txt | wc -l)

echo "Liczba transkryptów, na które będą miały wpływ polimorfizmy: " $transcripts_file

# Ile procent polimorfizmów znajduje się w intronach ------ BASH
#let intron_counter=0
let all_polym=$(cat $vep | wc -l )

#for line in $(cat $vep | cut -f 7):
#do
#	if [[ $line == "intron_variant" ]]; then
#		let "intron_counter++"
#	fi
#done
#echo "Całkowita liczba intronów: "$intron_counter

#Ile procent polimorfizmów znajduje się w intronach ------ AWK
introns= awk '/intron_variant/ {count++} END {print count}' $vep > introny.txt
int_introny=$(cat 'introny.txt')

perc_intron=$(echo "scale=2; $int_introny*100/$all_polym" | bc)
echo "Procentowa zawartość intronów: " $perc_intron "%"

# Ile procent polimorfizmów jest synonimicznych ?
let synonymous_counter=0

for line in $(cat $vep | cut -f 7):
do
	if [[ $line == "synonymous_variant" ]]; then
		let "synonymous_counter++"
	fi
done

perc_synonymous=$(echo "scale=2; $synonymous_counter*100/$all_polym" | bc)
echo "Procentowa zawartość mutacji synonimicznych: " 
echo $perc_synonymous "%"

# Polimorfizmy o potencjalnie wysokim wpływie na kodowane białka
echo "Ilość polimorfizmów o pot. wysokim wpływie na kodowane białka:"
 
awk -F '\t' '/IMPACT=HIGH/ {print $14}' drosophila.vep | sort | uniq -c | sort -nr | wc -l

#Ile delecji leży w regionach międzygenowych
echo "Delecje w regionach międzygenowych"
awk '/deletion/ {print $1} /intergenic_variant/ {print $7}' $vep | wc -l

#Lista genów do programu gene ontology
echo "Lista genów gene ontology została przygotowana w pliku 'prepared_genes.txt'"
awk '/FBgn/ {print $2}' genes.txt > prepared_genes.txt