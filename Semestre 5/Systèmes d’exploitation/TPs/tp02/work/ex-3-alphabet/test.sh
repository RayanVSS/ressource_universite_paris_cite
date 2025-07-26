#!/bin/bash

SUCCESS=true


echo_red() {
  if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    echo -n "$(tput setaf 1)$(tput bold)" 2>/dev/null
    echo -n $@
    echo -n "$(tput sgr0)" 2>/dev/null
  else
    echo $@
  fi
}

init() {
  alphabet=$(mktemp)
  alphabet_append=$(mktemp)
  out=$(mktemp)
  out_append=$(mktemp)
}

clean() {
  rm -rf $alphabet $alphabet_append $out $out_append 
}

init

echo -n "Running ./cree-alphabet... "
./cree-alphabet $alphabet >| $out
if [[ `cat $out` != "abcdeklmno" ]]
then 
  echo_red "Failed: "
  echo "unexpected output on stdout"
else
  if [[ `cat $alphabet` != "abcdeFGHIJklmnoPQRSTuvwxyz" ]]
  then
    echo_red "Failed: "
    echo "the file has unexpected content"
  else
    echo OK
  fi
fi

echo -n "Running ./cree-alphabet-append... "
./cree-alphabet-append $alphabet_append >| $out_append
if [[ `cat $out_append` != "abcde" ]]
then
  echo_red "Failed: "
  echo "unexpected output on stdout"
else
  if [[ `cat $alphabet_append` != "abcdefghijklmnopqrstuvwxyzFGHIJPQRST" ]]
  then
    echo_red "Failed: "
    echo "the file has unexpected content"
  else
    echo OK
  fi
fi

clean


