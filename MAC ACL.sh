#!/bin/bash
echo "Please enter file to read"
#/home/andrei/Desktop/MAC
read file
cat "$file" |awk '{print $2}' >> "/tmp/mac"
while read line; do
echo "permit $line 00:00:00:00:00:00 any"
done < "/tmp/mac"
rm "/tmp/mac"

