#!/bin/bash
. /etc/bashmount-au.conf

inotifywait -m -r "$@" | while read path action file; do 

#file_owner="$(stat -L --format='%U' $path$file)"
#if [[ "$file_owner" != "${SUDO_USER}"* ]]; then
#   action=''
#fi
     
#temp fixes for system writing files and removing files multiple times per sec
  if [[ "$path$file" == "/tmp/vte"* ]]; then
      action=''
  fi

  if [[ "$path$file" == "/var/centrifydc/user/" ]]; then
      if [[ "$action" == "ATTRIB,ISDIR" ]]; then
         action=''
      fi
  fi


  #sets timestamp
  date_fmt="$(date +%D-%H-%M-%S)"

send_to_log () {

   echo "${date_fmt}":"${path}""${file}":"${action}" >> "${logfile}"

}

run_action () {

    case $action in

         MOVED_FROM)
          action="moved from ${path}"; send_to_log "${path}" "${file}" "${action}";;
	 MOVED_TO)
	  action="moved to ${path}"; send_to_log "${path}" "${file}" "${action}";;
         UNMOUNT)
	  action="directory unmounted"; send_to_log "${path}" "${file}" "${action}";;
         ACCESS)
	  action="file read"; send_to_log "${path}" "${file}" "${action}";;
         MODIFY)
          if [[ "$save_copy" == "yes" ]]; then
             cp $path$file $save_copy_directory/$SUDO_USER/"$(date +%F)"
          fi
             action="file written"; send_to_log "${path}" "${file}" "${action}";;
         ATTRIB)
          action="file attributes modified"; send_to_log "${path}" "${file}" "${action}";;
         ATTRIB,ISDIR)
          action="directory attributes modified"; send_to_log "${path}" "${file}" "${action}";;
	 OPEN)
          action="file opened"; send_to_log "${path}" "${file}" "${action}";;
         CREATE)
          if [[ "$save_copy" == "yes" ]]; then
             cp $path$file $save_copy_directory/$SUDO_USER/"$(date +%F)"
          fi
             action="file created"; send_to_log "${path}" "${file}" "${action}";;
	 DELETE)
            action="file deleted"; send_to_log "${path}" "${file}" "${action}";;
         CLOSE_WRITE,CLOSE)
	  action="file closed after opened in write mode"; send_to_log "${path}" "${file}" "${action}";;
         CLOSE_NOWRITE,CLOSE)
          action="file closed after opened in read-only mode"; send_to_log "${path}" "${file}" "${action}";;
	 CREATE,ISDIR)
           if [[ "$save_copy" == "yes" ]]; then
              cp $path$file $save_copy_directory/$SUDO_USER/"$(date +%F)"
           fi
	  action="directory created"; send_to_log "${path}" "${file}" "${action}";;
         DELETE,ISDIR)
          action="directory deleted"; send_to_log "${path}" "${file}" "${action}";;
	 UNMOUNT)
          action="directory unmounted"; send_to_log "${path}" "${file}" "${action}";; 
         # Probably don't want any "listings" actions. Uncommment if desired.
         #CLOSE_NOWRITE,CLOSE,ISDIR)
	  #action="listing directory"; send_to_log "${path}" "${file}" "${action}";;;
         #OPEN,ISDIR)
	  #action="listing directory"; send_to_log "${path}" "${file}" "${action}";;
         #*)
	  #action=$action; send_to_log "${path}" "${file}" "${action}";;
   
   esac
}

  if [[ "$save_copy" == "yes" ]]; then
    if [[ "$log_mountpoint_only" == "yes" ]]; then
     mkdir -p $save_copy_directory/$SUDO_USER/"$(date +%F)"
    fi
  fi

  if [[ "$log_mountpoint_only" == "yes" ]]; then
     if [[ "$path" == "${1}/" ]]; then
        run_action
     fi
  else
        run_action
  fi


done &

exit 0


