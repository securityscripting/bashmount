touch "${2}"
temp_dir=/tmp/kde-"${1}"
inotifywait -m -r $temp_dir | while read path action file; do 
cp $temp_dir/$file "${2}" 2>/dev/null
done &
exit 0

