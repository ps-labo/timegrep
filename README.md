# timegrep

## NAME
timegrep - extract lines from textdata with specified terms, implemented by perl.

## SYNOPSIS

### Extract recent 30 minutes data from now.
	$ date
	Tue Nov 13 08:20:11 JST 2012

	$ cat access_log | timegrep --recent=30
	

	* If timegrep has executed with any parameters, use "--recent=60" for default value.


### Extract with specified date and time.
	$ head access_log
	$ tail access_log
	$ cat access_log | timegrep --start="2012/11/13 07:50:11" --end="2012/11/13 08:20:11"

### Extract with specified time
	* in this case, regard date as today.

	$ head access_log
	$ tail access_log
	$ cat access_log | timegrep --start="07:50:11" --end="08:20:11"

### Acceptable datetime formats on textdata..

	This script has detected belows datetime formats on textdata.

	13/Nov/2012:13:20:07 +0900 ( like as apache format )
	13/11/2012 13:20:07
	13/11/2012:13:20:07
	11 13, 2012 13:20:07
	11 13, 2012 01:20:07 pm
	11 13, 2012 01:20:07 PM
	2012/11/13 13:20:07
	2012年 11月13日 火曜日 13時20分07秒 JST
	Tue Nov 13 13:20:07 JST 2012
	1352780407 (unix time)


### Acceptable datetime formats with parameter --start / --end.

	for --start and --end parameter, it accepts belows formats.

	* omission value treats as 00
	2012/11/13 13:20:07
	2012/11/13 13:20
	2012/11/13 13
	2012/11/13

	* omission date regards as today, and omission second and minute treats as 00
	13:20:07
	13:20
	13

	And also, can use "on textdata" formats.

## AUTHOR
Kazuhiro INOUE

## LICENSE
This script is free softwere.


