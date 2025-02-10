echo "FASTA File Statistics:"
echo "----------------------"
for fasta in genes.fa
     do
echo "Number of sequences:$(grep '>' $fasta | wc -l)"
echo "Total length of sequences"
echo "Length of the longest sequence"
echo "Length of the shortest sequence"
echo "Average sequence length"
echo "GC Content (%)"

done
