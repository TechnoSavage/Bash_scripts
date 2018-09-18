#!/bin/bash

#Create a one year folder structure in the form of year -> months -> days
PROGNAME=$(basename $0)

usage () {
  echo "$PROGNAME: Usage $PROGNAME [ -y year -l location | -i interactive]
  -y | --year          Root folder name for the folder structure
  -l | --location      Path where the folder structure should be created
  -i | --interactive   Use in interactive mode"
  return
}

year=
location=
interactive=

while [[ -n $1 ]]; do
    case $1 in
      -y | --year)        shift
                          year=$1
                          ;;
      -l | --location)    shift
                          location=$1
                          ;;
      -i | --interactive) interactive=1
                          ;;
      -h | --help)        usage
                          exit
                          ;;
      *)                  usage >&2
                          exit 1
                          ;;
    esac
    shift
done
if [[ -n $interactive ]]; then
  read -p "Enter the location where folder structure should be created [$HOME/Pictures/]: " location
  if [[ $location == "" ]] && [[ -e $HOME/Pictures ]]; then
    location="$HOME/Pictures"
  else
    mkdir $HOME/Pictures
    location="$HOME/Pictures"
  fi
  read -p "Enter the year number for the folder structure: " year
fi
if [[ -n $year ]]; then
  if [[ ! -e $location ]]; then
    read -p "Location does not exist; create it now? [y/n]: " response
    response=$( echo $response | tr '[:upper:]' '[:lower:]' )
    case $response in
      y | yes)   mkdir $location
                 ;;
      n | no)    echo "Directory not created; exiting."
                 exit 1
                 ;;
    esac
  fi
  if [[ ! -d $location ]]; then
    echo "$location is not a Directory."
    exit 1
  fi
  cd $location && mkdir $year && mkdir $year/0{1..9} $year/1{0..2} && cd $year
  for folder in *
    do
      mkdir $folder/0{1..9} $folder/{1..2}{0..9} $folder/3{0..1}
    done
  rm -r $location/$year/02/{29..31} $location/$year/04/31 $location/$year/06/31 $location/$year/09/31 $location/$year/11/31
else
  usage
fi
