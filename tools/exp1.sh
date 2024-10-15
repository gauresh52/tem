#List files in crnt dir
echo "Listing all files in the current directory:"
ls 

#Merge the files starting with letter 'a'
file_count=0
fName="merged_file_a.txt"

for file in a*; do
    if [ -f "$file" ]; then
        cat "$file" >> $fName
        file_count=$((file_count + 1))
    fi
done

if [ $file_count -eq 0 ]; then
    echo "No files starting with 'a' found to merge."
    rm $fName
else
#rename
    mv $fName "merge_files_a_(${file_count}).txt"
fi
