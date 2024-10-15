#!/bin/bash

# a) List the files in the current directory
echo "Listing all files in the current directory:"
ls -l

# b) Merge the files starting with letter 'a'
merged_content=""
file_count=0

for file in a*; do
    if [ -f "$file" ]; then
        cat "$file" >> merged_files_a.txt
        file_count=$((file_count + 1))
    fi
done

# Check if any files starting with 'a' were found and merged
if [ $file_count -eq 0 ]; then
    echo "No files starting with 'a' found to merge."
    rm merged_files_a.txt
else
    # c) Rename the file as merge_files_a_(number of files merged).txt
    mv merged_files_a.txt "merge_files_a_(${file_count}).txt"
    echo "Merged $file_count files into merge_files_a_(${file_count}).txt"
fi