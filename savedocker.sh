#!/bin/bash

#IFS=$'\n'
while read myline
do
  newline=( ${myline} )
  img_name="${newline[0]}:${newline[1]}"
  file_name="${newline[0]}-${newline[1]}"
  echo "Saving image: ${img_name} to ${file_name}.tar"
  docker save -o ${file_name}.tar ${img_name}
  echo "Compressing file: ${file_name}.tar..."
  gzip ${file_name}.tar
  echo "...."
done < <(docker images mysql --format "{{.Repository}} {{.Tag}}")
