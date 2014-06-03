### This script goes through sound and TextGrid files in a directory and measure
### fricatives. It records COG, SD, skewness, and kurtosis.
### Written by Kota Hattori

### Set up a directory and a result file.

form Analyze formant values from labeled segments in files

	comment Specify a directory
	text directory /Users/name/Documents/fricative measure/measure
	comment Full path of the resulting text file:
	text resultfile /Users/name/Documents/fricative measure/RESULTS.txt
	comment Give a name to a tier
	sentence Tier fricative
	comment Who is the talker?
	text talker

endform


### Make a list of all wav files and TexGrid files in a directory, respectively.

strings = Create Strings as file list: "soundlist", directory$ + "/*.wav"
strings2 = Create Strings as file list: "gridlist", directory$ + "/*.TextGrid"

numberOfFiles = Get number of strings


### Check if the result file exists:
if fileReadable (resultfile$)

	pause The result file 'resultfile$' already exists! Do you want to overwrite it?

	filedelete 'resultfile$'

endif


### Write a row with column titles to the result file:
### This is like giving column names to a matrix in R.

titleline$ = "word	sound	cog	sd	skew	kurtosis	start	end	duration	talker'newline$'"

### No space allowed between " and '

fileappend "'resultfile$'" 'titleline$'



###
### Acoustic measure force: Go through all the sound files, one by one
###

for i to numberOfFiles

	selectObject: strings 
    	fileName$ = Get string: i
    	foo = Read from file: directory$ + "/" + fileName$

    	selectObject: strings2
    	gridfileName$ = Get string: i
    	foo2 = Read from file: directory$ + "/" + gridfileName$

	selectObject: foo
	plusObject: foo2
	
	View & Edit

	pause  Specify a fricetive by adding two intervals. Provide a label. Then, click OK.

### I need to add two intervals, give a label (e.g., S), and select the fricative part by clicking.

### Now I extract a fricative name (label$) and its duration using the TextGrid 

	selectObject: foo2
	
	### The 1st number is tier number, and the 2nd is interval number.
	label$ = Get label of interval: 1, 2
	start = Get start point: 1, 2
	end =  Get start point: 1, 3
	duration = end - start


### Here "editor foo" should work if I follow logic. But, Praat cannot take this line as of 
### 27th of May, 2014. I decided to go around here. Delete a file extension and create
### a new variable (soundName$). Use it when I open a sound file.

	soundName$ = fileName$ -".wav"

	selectObject: foo
	Resample: 20000, 50
	select Sound 'soundName$'_20000
	Extract part: start, end, "rectangular", 1, "no"
	select Sound 'soundName$'_20000_part
	To Spectrum: "yes"
	select Spectrum 'soundName$'_20000_part

	cog = Get centre of gravity: 2
	sd = Get standard deviation: 2
	skew = Get skewness: 2
	kurtosis = Get kurtosis: 2

endeditor

### Save result to a text file
### Praat records the folloiwng variables in each row of the result file.
### Tab is necessary between variables.

	resultline$ = "'soundName$'	'label$'	'cog'	'sd'	'skew'	'kurtosis'	'start'	'end'	'duration'	'talker$''newline$'"

	fileappend "'resultfile$'" 'resultline$'

	selectObject: foo
	plusObject: foo2
	plusObject: "Sound 'soundName$'_20000"
	plusObject: "Sound 'soundName$'_20000_part"
	plusObject: "Spectrum 'soundName$'_20000_part"

	Remove

endfor

### Remove lists for sound and textgrid files.

select all

Remove
