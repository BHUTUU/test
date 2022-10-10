#!/bin/bash
sig1() {
words=('dmVyeQ==' 'Z29vZA==' 'QkhVVFVV')
for i in ${words[@]}; do
  toilet -f mono12 -F gay $(printf "$i" | base64 -d)
done
}
sig() {
  printf "\033[?12l\033[?25h\r $(printf "R1VTU0EgTVQgSE8gTkEgQkhVVFVVIFBMRUFTRSDwn6W6"| base64 -d)\ni"
}
sig2() {
clear;printf "\n\n\n"
trap sig SIGINT
m=" "; d=1
a=('|' '/' '-' '\'); printf "\033[?25l"
while [ 1 ]; do
  for i in ${a[@]}; do
    printf "\r$(printf "QkhVVFVV" | base64 -d) ${m}🚂🚞 $(printf "U09SUlkuLg==" | base64 -d) $i"
    m+=" "; let d++
    sleep 0.1
  done
  if [ $d -gt '25' ]; then sig;break; fi
done
}
if [[ $1 == "-1" ]]; then
sig1
elif [[ $1 == "-2" ]]; then
sig2
fi
