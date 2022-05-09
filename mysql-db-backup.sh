backup=/home/ubuntu/db-backup

if [ -d $backup ]; then
echo "Creating backup";
else
echo "Creating backup folder.";
eval `mkdir -p db-backup`;
fi

host=
user=
password=
db=
filename=$backup/saga-$(date '+%Y-%m-%d-%H-%M-%S').sql

mysqldump -h $host -u $user -p$password $db > $filename

if [ $? == 0 ]; then
echo 'Sql dump created'
else
echo 'mysqldump return non-zero code | No backup was created!'
exit
fi
