#!/bin/bash

#initialize the variables
c=0
a=0
pattern=""
path=""

# loop through the arguments provided and switch on c or a, and fill the variables pattern and path if they are provided
for i in $@
do
	if [ $i == "-c" ]
	then
		c=1
	elif [ $i == "-a" ]
	then
		a=1
	elif [ -z $pattern ] && [ -z $path ]
	then
		pattern=$i
	else
		path=$i
	fi
done 

# set the current directory to be the path in case no path is specified
if [ -z $path ]
then
	path="$(pwd)"
fi

# return an error and a usage message in case pattern is missing
if [ -z $pattern ]
then
	echo "Error missing the pattern argument."
	echo "Usage ./seeker.sh [-c] [-a] pattern [path]"
	exit 1

# if the path specified is missing, notify the user with an error message
elif [ ! -d $path ]
then
	echo "Error $path is not a valid directory"
	exit 1

# if the pattern specified is missing, notify the user that it could not be found
elif [ -z "$(ls $path | grep $pattern)" ]
then
	echo "Unable to locate any files that has pattern $pattern in its name in $path."

# if c switch is on and a switch is off, print the content of the first occurrence of the pattern
elif [ $c == 1 ] && [ $a == 0 ]
then
	echo "==== Contents of: $(echo $path/`ls $path | grep -m 1 $pattern`) ===="
	echo "`cat $(echo $path/$(ls $path | grep -m 1 $pattern))`"

# if c switch is off and a switch is on, print the list containing all the files matching the pattern
elif [ $c == 0 ] && [ $a == 1 ]
then
	for i in $(ls $path | grep $pattern)
	do
		echo "$path/$i"
	done

# if both switches are on, print the contents of each file matching the pattern by looping through each file
elif [ $c == 1 ] && [ $a == 1 ]
then
	for i in $(ls $path | grep $pattern)
	do
		echo "==== Contents of: $path/$i ===="
		cat $path/$i
	done

# or else just print the absolute path to the file
else
	echo "$path/$(ls $path | grep -m 1 $pattern)"
fi
