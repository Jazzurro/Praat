# This script helps you make text grids. It opens all files from the specified directory one at a time
# creates a text grid for you. This was originally written by Kathryn Flack and Shigeto Kawahara
# Note that Praat syntax changed in May 2014. So I modified their script

### Define a directory

form Open all files in directory
   text directory /Users/name/Documents/fricative measure/measure/
endform

### Create a list with the names of the wav files and get the number of the files.

strings = Create Strings as file list: "list", directory$ + "/*.wav"
numberOfFiles = Get number of strings


# This loop opens each sound file and create a TextGrid withe the sound file name.

for ifile to numberOfFiles

# Select the stringlist and find a file name. Then, it reads that file.

    selectObject: strings
    fileName$ = Get string: ifile
    Read from file: directory$ + "/" + fileName$


# Now we define an object name - a file name minus extension. This is useful because
# then we can refer to the text grid file and the sound file by using the object name,
# which is a variable. See below

     	object_name$ = "'fileName$'" - ".wav"
  
# Select a sound now.

   	select Sound 'object_name$'

# Creat a text grid file with a tier named "sentence". This name is not important.
# It can be anything.

	To TextGrid: "vowel", "" 
	select TextGrid 'object_name$'

# Then save it as a text file with "TextGrid" extension.

     	Write to text file... 'directory$''object_name$'.TextGrid

# Now we get rid of all the files from the menu window.

     	select all
     	minus Strings list
     	Remove

# And it ends if it goes through all the files in the directory.

endfor

# After the loop, let's clear off all the window.

select all
Remove
