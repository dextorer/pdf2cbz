#!/bin/bash

EXT="pdf"
DENSITY="300"
GLOBAL_FILENAME=""

echo "
#############################################
#                _________        __        #
#     ____  ____/ / __/__ \ _____/ /_  ____ #
#    / __ \/ __  / /_ __/ // ___/ __ \/_  / #
#   / /_/ / /_/ / __// __// /__/ /_/ / / /_ #
#  / .___/\__,_/_/  /____/\___/_.___/ /___/ #
# /_/                                       #
#											#
#				   DextoR®					#
#											#
#############################################"

# Calls the convert command to extract JPGs from the PDF
function make_convert {
	CURRENT_FILE=$1
	FILENAME=${CURRENT_FILE%.*}
	GLOBAL_FILENAME=$FILENAME
	
	if [ -d $FILENAME ] ; then
		echo "Directory already exists!"
		exit $?
	fi

	mkdir $FILENAME
	echo "Created a working directory. Moving into it.."
	cd $FILENAME

	echo "Copying $CURRENT_FILE for processing.."
	cp ../$CURRENT_FILE .

	echo "Converting.. "
	convert -debug "None" $CURRENT_FILE $FILENAME.jpg

	echo " Conversion completed."
	make_compress $FILENAME
}

# Compresses a series of JPGs into a CBZ archieve
function make_compress {
	CURRENT_FILE=$1
	echo "Compressing.."
	zip $CURRENT_FILE.cbz *.jpg
	if [ ! -f $CURRENT_FILE.cbz ] ; then
		echo "Compression failed!"
		exit $?
	fi

	echo " Compression completed. The result filename is $CURRENT_FILE.cbz "
	make_cleanup $FILENAME.cbz
}

# Cleans up the place
function make_cleanup {
	CURRENT_FILE=$1
	echo "Cleaning up.. "
	cp $CURRENT_FILE ../
	cd ../
	rm -rf ${CURRENT_FILE%.*}/
	echo "All cleaned up. Lemony fresh!"
}

bashtrap()
{
    echo
    make_cleanup $GLOBAL_FILENAME
}


# main code

clear

INPUT=$1

if [ -d $INPUT ] ; then
	cd $INPUT
	for i in "*.$EXT"
		do
			echo "Processing" $i ".."
			make_convert $i
		done
else
	echo "Processing $INPUT .."
	make_convert $INPUT
fi