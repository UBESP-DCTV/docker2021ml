#! /bin/sh

current_dir=$(pwd)
uid=$(id -u)

docker run -d --rm --user $uid -v $current_dir:/home/rstudio/persistent-folder -e PASSWORD=docker2021ml -p 8787:8787 docker2021ml
