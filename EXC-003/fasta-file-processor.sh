echo "FASTA File Statistics:"
echo "----------------------"
for fasta in genes.fa
     do
echo "Number of sequences:$(grep '>' $fasta | wc -l)"
echo "Total length of sequences:$(grep -v '>' $fasta | tr -d '\n' | wc -c)"
echo "Length of the longest sequence:$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | sort -n | tail -n 1 | awk '{print $2}' | sed 's/>//g')"
echo "Length of the shortest sequence:$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | sort -n | head -n 1 | awk '{print $2}' | sed 's/>//g')"
echo "Average sequence length:$(awk 'BEGIN{FS=":"} />/{print $(NF), $0}' genes.fa | awk '{print $2}' | sed 's/>//g' | awk '{total_length += $1;
count++} END { print "Average sequence length:", total_length/count}')"
echo "GC Content (%):$(awk '/>/ {if (seq) print seq; seq=""; next} {seq=seq $0} END {print seq}' genes.fa | awk '{gc_count += gsub(/[GgCc]/, "", $0); total_bases += length($0)} END {printf "%.2f\n", (gc_count / total_bases) * 100}')"
done
