#!/bin/bash

watchdir1="${1}"
watchdir2="${2}"
logfile="${3}"

inotifywait -m -r "${watchdir1}" "${watchdir2}" | while read path action file; do 

#sets timestamp
date_fmt="$(date +%D-%H-%M-%S)"

send_to_log () {

      echo "${date_fmt}":"${1}""${2}":"${3}" >> "${logfile}"
}

    case $action in
         MOVED_FROM)
          action="moved from "${path}"; send_to_log "${path}" "${file}" "${action}";;
	 MOVED_TO)
	  action="moved to "${path}"; send_to_log "${path}" "${file}" "${action}";;
         UNMOUNT)
	  action="directory unmounted"; send_to_log "${path}" "${file}" "${action}";;
         ACCESS)
	  action="file read"; send_to_log "${path}" "${file}" "${action}";;
         MODIFY)
          action="file written"; send_to_log "${path}" "${file}" "${action}";;
         ATTRIB)
          action="file attributes modified"; send_to_log "${path}" "${file}" "${action}";;
         ATTRIB,ISDIR)
          action="directory attributes modified"; send_to_log "${path}" "${file}" "${action}";;
	 OPEN)
          action="file opened"; send_to_log "${path}" "${file}" "${action}";;
         CREATE)
          action="file created"; send_to_log "${path}" "${file}" "${action}";;
	 DELETE)
          action="file deleted"; send_to_log "${path}" "${file}" "${action}";;
         CLOSE_WRITE,CLOSE)
	  action="file closed after opened in write mode"; send_to_log "${path}" "${file}" "${action}";;
         CLOSE_NOWRITE,CLOSE)
          action="file closed after opened in read-only mode"; send_to_log "${path}" "${file}" "${action}";;
	 CREATE,ISDIR)
	  action="directory created"; send_to_log "${path}" "${file}" "${action}";;
         DELETE,ISDIR)
          action="directory deleted"; send_to_log "${path}" "${file}" "${action}";;
	 UNMOUNT)
          action="directory unmounted"; send_to_log "${path}" "${file}" "${action}";; 
         # Probably want to listings actions. Uncommment if desired.
         #CLOSE_NOWRITE,CLOSE,ISDIR)
	  #action="listing directory"; send_to_log "${path}" "${file}" "${action}";;;
         #OPEN,ISDIR)
	  #action="listing directory"; send_to_log "${path}" "${file}" "${action}";;
         #*)
	  #action=$action; send_to_log "${path}" "${file}" "${action}";;
   esac
 
done &

exit 0


