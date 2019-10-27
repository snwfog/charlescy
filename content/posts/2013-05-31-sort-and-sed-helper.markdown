---
layout: post
title: "sort and sed helper"
date: 2013-05-31 23:23
comments: true
categories: 
---
Here are some self memo that I've taken when I was looking through the tutorial on the Unix command `sed` from [this gentleman](https://www.youtube.com/watch?v=h5MpG3QYSSk) on YouYube.

# sort
```
sort - Sort the file
sort -t -k 1 - Sort file by column 1, delimited by comma
sort -r  - Reverse the sort
sort -n - Sort by numerical value
sort -f - Case insensitive sort
sort -t ' - Specify the separator of column
```
# sed
```
sed 's/pattern/& replacement/gi - & represents the pattern found
sed 's/\(group\)pattern/\1/gi' - \1 contains the capture group number
sed 's/search/replace/2g' - Replace second occurrence of search
sed -e 'Command 1' -e 'Command 2' - Run multiple commands
sed '/pattern/p' - Print out the occurrence of the pattern
sed 's/'"$VAR"'/replace/ - Using external variable from SHELL
sed '2 s/search/replace/gi' - Replace only occurrence in line 2
sed '/start/,/end/d' - Delete line from start to end
sed 'start,end!d' - Delete line NOT from start to end
sed -i - Destructive editing
sed 'y/letterpattern/letterpattern/' - Matching letter replacement
```
For even more helpful information about `sed`, [here](http://www.grymoire.com/Unix/Sed.html) is a good place.