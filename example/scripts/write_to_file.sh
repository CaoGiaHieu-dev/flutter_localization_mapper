
#!/bin/bash

# check if enough arguments were provided
if [ $# -lt 2 ]; then
    echo "Error: Not enough arguments provided."
    echo "Usage: $0 <file> <line_number> <string_to_add>"
    exit 1
fi

# assign input arguments to variables
file=$1
line_number=$2
string_to_add=$3

# backup the original file
cp $file "$file.bak"

# add the string to the desired line and write the result to a new file
counter=0
while read line; do
    ((counter++))
    if [ $counter -eq $line_number ]; then
        echo "$string_to_add$line" >> "$file.tmp"
    else
        echo "$line" >> "$file.tmp"
    fi
done < "$file"

# overwrite the original file with the new file
mv "$file.tmp" "$file"

echo "String addition completed successfully."
