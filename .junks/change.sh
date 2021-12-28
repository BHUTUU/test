#!/usr/bin/env bash
set -x
read -p "Enter word to capture: " capt
read -p "Enter word to replce with: " rept
change() {
  sed -i "s+$capt+$rept+g" $(pwd)/$1
}
yep() {
  for yep in $(ls); do
    if [[ -f "$(pwd)/${yep}" ]]; then
      change ${yep}
    elif [[ -d "$(pwd)/${yep}" ]]; then
      cd $(pwd)/${yep}
      ha 
    else
      CWD=$(pwd)
      while read -r X; do
        if [[ $X == $CWD ]]; then
          break
        fi
      done <<< "${HOME}/mems"
      echo $CWD >> $HOME/.mems
      cd ..
    fi
  done
}
ha() {
  for ha in $(ls); do
    if [[ -f "$(pwd)/${ha}" ]]; then
      change ${ha}
    elif [[ -d "$(pwd)/${ha}" ]]; then
      cd $(pwd)/${ha}
      yep 
    else
      CWD=$(pwd)
      while read -r X; do
        if [[ $X == $CWD ]]; then
          break
        fi
      done <<< "${HOME}/mems"
      echo $CWD >> $HOME/.mems
      cd ..
    fi
  done
}

#<======Action=====>#
crd=$(pwd)
for i in $(ls); do
  if [ -f ${crd}/${i} ]; then
    change ${i}
  else
    cd ${crd}/${i}
    ha
  fi
done

