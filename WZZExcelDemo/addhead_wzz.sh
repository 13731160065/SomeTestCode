#!/bin/sh
cmdfile="addhead_wzz.sh"
addr="$1"

for filename in `ls`
do
	if [ $cmdfile != $filename ] 
	then 
		newfilename=$addr$filename #=不能有空格
		echo $newfilename
		mv $filename $newfilename
	fi
done
