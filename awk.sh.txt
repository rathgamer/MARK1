echo 'To define an awk script, use braces surrounded by single quotation marks'
awk 'BEGIN {print "Welcome to awk command tutorial"}'

echo 'To print the squares of first numbers from 1 to n say 6'
awk 'BEGIN { for(i=1;i<=6;i++) print "square of", i, "is",i*i; }'

echo ' It prints all the lines of the file'
awk '{print}' f1.txt

echo 'It prints all the line which matches with the ‘manager’'
awk '/manager/ {print}' f1.txt

echo '$1 and $4 represents Name and Salary fields respectively'
awk '{print $1,$4}' f1.txt

echo 'It prints Name and Salary fields of the ‘manager’'
awk '/manager/ {print $1,$4}' f1.txt

echo 'NR prints all the lines along with the line number'
awk '{print NR,$0}' f1.txt

echo '$1 represents Name and $NF represents Last filed'
awk '{print $1,$NF}' f1.txt

echo 'It displays Line From 3 to 6'
awk 'NR==3, NR==6 {print NR,$0}' f1.txt

echo 'It prints the Names along with the line number with a "." (1.ajay)'
awk '{print NR "." $1}' f1.txt

echo 'To print any non empty line if present'
awk 'NF > 0' f1.txt

echo 'To find the length of the longest line present in the file'
awk '{ if (length($0) > max) max = length($0) } END { print max }' f1.txt

echo 'To count the lines in a file'
awk 'END { print NR }' f1.txt

echo 'To find a string in a specific column'
awk '{ if($1 == "amit") print $0}' f1.txt

echo 'To print Names who has salary more than 15000'
awk '{if ($NF > 15000) print $1,$NF}' f1.txt


