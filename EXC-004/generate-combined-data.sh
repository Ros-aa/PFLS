mkdir -p COMBINED-DATA
MAG_counter=1
BIN_counter=1

for dir in $(find RAW-DATA -type d -name "DNA*"); do
    culture_name=$(basename "$dir")
    new_culture_name=$(awk -v culture="$culture_name" '$1 == culture {print $2}' RAW-DATA/sample-translation.txt)

    if [ -z "$new_culture_name" ]; then
        echo "No match found for culture $culture_name"
        continue
    fi

    if [ -f "$dir/checkm.txt" ]; then
        cp "$dir/checkm.txt" "COMBINED-DATA/$new_culture_name-CHECKM.txt"
    else
        echo "checkm.txt not found in $dir"
    fi

    if [ -f "$dir/gtdb.gtdbtk.tax" ]; then
        cp "$dir/gtdb.gtdbtk.tax" "COMBINED-DATA/$new_culture_name-GTDB-TAX.txt"
    else
        echo "gtdb.gtdbtk.tax not found in $dir"
    fi

    for fasta_file in $dir/bins/*.fasta; do
        bin_name=$(basename "$fasta_file" .fasta)

        completion=$(grep "$bin_name " "$dir/checkm.txt" | awk '{print $13}')
        contamination=$(grep "$bin_name " "$dir/checkm.txt" | awk '{print $14}')
        if [[ $bin_name == "bin-unbinned" ]]; then
            new_name="${new_culture_name}_UNBINNED.fa"
        elif (( $(echo "$completion >= 50" | bc -l) && $(echo "$contamination < 5" | bc -l) )); then
            new_name=$(printf "${new_culture_name}_MAG_%03d.fa" $MAG_counter)
            MAG_counter=$((MAG_counter + 1))
        else
            new_name=$(printf "${new_culture_name}_BIN_%03d.fa" $BIN_counter)
            BIN_counter=$((BIN_counter + 1))
        fi
        cp "$fasta_file" "COMBINED-DATA/$new_name"
        awk -v prefix="$new_culture_name" '{if ($0 ~ /^>/) {print ">" prefix "_" NR} else {print}}' "$fasta_file" > "COMBINED-DATA/$new_name"

        echo "Processed $fasta_file -> COMBINED-DATA/$new_name with new headers"
    done
done

