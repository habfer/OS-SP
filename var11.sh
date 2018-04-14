#!/bin/bash

#11.	Написать скрипт, считающий для заданного каталога и всех его подкаталогов суммарный размер и количество файлов в заданном диапазоне размеров файлов (имя каталога задаётся пользователем в качестве аргумента командной строки, 2,3 аргументы командной строки диапазон размеров). Результаты выводятся на консоль в виде полный путь, количество файлов, суммарный размер.

IFS=$'\n'
ERR_LOG="/tmp/err.log"
declare -i filesize TotalSize count

exec 3>&2 2>$ERR_LOG

dirnm=`find $1 -type d`


for i in $dirnm; do
  count=0
  TotalSize=0
  filenm=`find $i -maxdepth 1 -type f -size +$2c -size -$3c`
  if [[ $2 =~ ^[0-9]+$  ]] && [[ $3 =~ ^[0-9]+$ ]]
  then
    for j in $filenm; do
      filesize=`stat $j -c %s`
      TotalSize=TotalSize+filesize
      count+=1
    done
    echo "`readlink -e $i` $count $TotalSize"
  else
    exec 2>&3 3>&-
    sed "s/.[a-zA-Z]*:/`basename $0`:/" < $ERR_LOG>&2
    rm $ERR_LOG
    exit 0	
  fi
done

exec 2>&3 3>&-
sed "s/.[a-zA-Z]*:/`basename $0`:/" < $ERR_LOG>&2
rm $ERR_LOG

exit 0
