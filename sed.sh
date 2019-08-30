echo 'Print the file'
more file.txt

echo 'Changes the 1st occurence of the given word'
sed 's/OS/Operating System/' file.txt

echo 'Changes the the given word globally'
sed 's/OS/Operating System/g' file.txt

echo 'subs the '.' to ',' globally'
sed 's/\./,/g' file.txt

echo 'subs the OS as (OS) globally'
sed 's/OS/(&)/g' file.txt

echo 'subs the OS into Operating System starting from the 2nd occurence in all lines'
sed 's/OS/Operating System/2g' file.txt

echo 'subs the 1st occurence number in the 4th line to nothing'
sed '4 s/[0-9]//' file.txt

echo 'subs the gmail to yahoo in the line which starts with @'
sed '/^@/s/gmail/yahoo/' file.txt

echo 'subs the 1st occurence OS with Operating System in the 1st line'
sed '1 s/OS/Operating System/' file.txt

echo 'subs the 1st occurence Process with Job from 3rd line to end of file'
sed '3,$ s/Process/Job/' file.txt

echo 'subs Process with Job from 3rd line to end of file globally'
sed '3,$ s/Process/Job/g' file.txt

echo 'deletes from 3rd line to 9th line'
sed '3,9 d' file.txt

echo 'duplicates all the lines'
sed 'p' file.txt

echo 'prints all tje lines which doesn't have OS'
sed -n '/OS/!p' file.txt
