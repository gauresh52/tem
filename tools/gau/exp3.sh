#!/bin/bash

# Array of English words representing numbers
declare -A number_words
number_words=( ["zero"]=0 ["one"]=1 ["two"]=2 ["three"]=3 ["four"]=4 ["five"]=5 ["six"]=6 ["seven"]=7 ["eight"]=8 ["nine"]=9 
               ["ten"]=10 ["eleven"]=11 ["twelve"]=12 ["thirteen"]=13 ["fourteen"]=14 ["fifteen"]=15 ["sixteen"]=16 ["seventeen"]=17 
               ["eighteen"]=18 ["nineteen"]=19 ["twenty"]=20 ["thirty"]=30 ["forty"]=40 ["fifty"]=50 ["sixty"]=60 ["seventy"]=70 
               ["eighty"]=80 ["ninety"]=90 ["hundred"]=100 ["thousand"]=1000 ["million"]=1000000 ["billion"]=1000000000 )

# Array of colors
declare -A colors
colors=( ["red"]=1 ["yellow"]=1 ["blue"]=1 ["green"]=1 ["black"]=1 ["white"]=1 ["orange"]=1 ["purple"]=1 ["brown"]=1 ["pink"]=1 
         ["gray"]=1 ["grey"]=1 ["violet"]=1 ["indigo"]=1 ["magenta"]=1 ["cyan"]=1 )

# Function to classify a word
classify_word() {
    local word="$1"
    
    # Check if the word is a license plate number 
    if [[ "$word" =~ ^([a-zA-Z]{2})[[:space:]]([0-9]{2})[[:space:]]([a-zA-Z]{1})[[:space:]]([0-9]{4})$ ]]; then
        echo "$word (License Plate Number)" >> Output
    
    # Check if the word is a date in formats such as DD/MM/YYYY, MM/DD/YYYY, YYYY-MM-DD
    elif [[ "$word" =~ ^([0-9]{2})[-/\.]([0-9]{2})[-/\.]([0-9]{4})$ || "$word" =~ ^([0-9]{4})[-/\.]([0-9]{2})[-/\.]([0-9]{2})$ ]]; then
        echo "$word (Date)" >> Output

    # Check if the word is a number
    elif [[ "$word" =~ ^[0-9]+$ ]]; then
        echo "$word (Number)" >> Output

    # Check if the word contains only English letters
    elif [[ "$word" =~ ^[a-zA-Z]+$ ]]; then
        # Check if the word is a number in words
        if [[ "${number_words[$word]}" != "" ]]; then
            echo "$word (Number in Words)" >> Output
        elif [[ "${colors[$word]}" != "" ]]; then
            echo "$word (Color)" >> Output
        else
            echo "$word (English Word)" >> Output
        fi
  
    # Check if the word contains only punctuation
    elif [[ "$word" =~ ^[[:punct:]]+$ ]]; then
        echo "$word (Special Character)" >> Output
  
    # Check if the word is a Devanagari word
    elif echo "$word" | grep -qP '^\p{Devanagari}+$'; then
        echo "$word (Devanagari Word)" >> Output
  
    # Check if the word contains a number within letters
    elif [[ "$word" =~ [0-9] ]]; then
        echo "$word (Number in Word)" >> Output

    
    
   
    # If none of the above conditions match, classify as Others
    else
        echo "$word (Others)" >> Output
    fi
}

# Function to classify a line of text
classify_line() {
    local line="$1"
    
    # Check for the license plate pattern in the entire line
    if [[ "$line" =~ ([a-zA-Z]{2})[[:space:]]([0-9]{2})[[:space:]]([a-zA-Z]{1})[[:space:]]([0-9]{4}) ]]; then
        echo "$BASH_REMATCH (License Plate Number)" >> Output
        return
    fi
    
    # Split line into words based on whitespace
    read -a words <<< "$line"
    
    # Check for numbers written in words
    local is_number_in_words=1
    for word in "${words[@]}"; do
        if [[ "${number_words[$word]}" == "" ]]; then
            is_number_in_words=0
            break
        fi
    done

    if [[ $is_number_in_words -eq 1 ]]; then
        echo "$line (Number in Words)" >> Output
        return
    fi
    
    for word in "${words[@]}"; do
        classify_word "$word"
    done
}

# Clear the contents of Output or create it if it doesn't exist
> Output

# Process each *.txt file in the current directory
for file in *.txt
do
    echo "Processing $file..."
    
    # Read each line from the current file and process word by word
    while IFS= read -r line || [[ -n "$line" ]]
    do
        # Skip empty lines
        if [[ -z "$line" ]]; then
            continue
        fi
        
        classify_line "$line"
        
    done < "$file"  # Read from the current *.txt file

    echo "Classification for $file complete."
done

echo "All files processed. Check Output for results."
exit 0
