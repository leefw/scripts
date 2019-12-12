#! /bin/bash

# Creates the necessary icons for use in an iOS app from a given 1024 PNG source 

#set -x

# Capture the path to the image file to use as source

inputPath=$1
outputPrefix=$2

# Need an input file if none given as argument

if [ -z $inputPath ] 
then
    printf "Enter input file path: "
    read inputPath
fi

printf "Using on '%s' as file input\n" $inputPath

# Check for file existance

if [ ! -e $inputPath ]
then
    echo "File $inputPath does not exist"
    exit 42
fi

# Capture the app icon base name

# Need an output file prefix if none given as argument 

if [ -z $outputPrefix ] 
then
    printf "Enter an output file prefix. The prefix will be used as part of the name for created files: "
    read outputPrefix
fi

# Do some parsing to get the basic icon file naming ready?

outputSuffix="png"

# Create an array/map of known filenames prefixes with their respective image sizes

sizes=("29x1:29" "29x2:58" "29x3:87" "40x1:40" "40x2:80" "40x3:120" "60x2:120" "60x3:180" "76x1:76" "76x2:152")

# For each entry 
#   Copy the file 
#   Resize the new file to the new size using "sips -Z <size> <filename>

counter=0

for i in "${sizes[@]}"
do
    key=${i%%:*}  # file name prefix value
    value=${i#*:} # image size value
    
    newName="$outputPrefix-$key.$outputSuffix"
    printf "Creating new file '%s' with size %s\n" $newName $value
    
    if [ ! -e $newName ]
    then
        cp $inputPath $newName
        sips -Z $value $newName
        counter=$((counter+1))
    else
        printf "File '%s' already exists\n" $newName
    fi
done

printf "Files processed: %s\n" $counter

#set +x