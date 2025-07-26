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
  rep_tmp=$(mktemp -d)
  fic_existant="$rep_tmp/tata"
  fic_inexistant="$rep_tmp/titi"
  rep_inaccessible=$(mktemp -d)
  echo -n "turlu" > "$fic_existant"
  fic_inaccessible="$rep_inaccessible/toto"
  touch "$fic_inaccessible"
  chmod 000 "$rep_inaccessible"
}

clean() {
  chmod 700 $rep_inaccessible $rep_tmp
  rm -rf $rep_inaccessible $rep_tmp
}

one_test() {  # $1 $2 $3 : argv $4 : exit code $5 : content
  $1 $2 $3 > /dev/null 2>&1
  if [[ $? != $4 ]] 
  then
    echo_red -e "Failed: "
    echo "expected exit code: $4"
  else
    if [[ "$5" == "" || `cat $3` == "$5" ]]
    then
      echo OK
    else
      echo_red -e "Failed\n"
    fi
  fi
}

chmod u+rwx .

## test cree
  init
  echo -n "Running ./cree on non existing file... "
  one_test ./cree tutu $fic_inexistant 0 tutu
  echo -n "Running ./cree on existing file... "
  one_test ./cree tutu $fic_existant 2 turlu
  echo -n "Running ./cree on non accessible file... "
  one_test ./cree tutu $fic_inaccessible 1
  clean

## test ecrase
  init
  echo -n "Running ./ecrase on non existing file... "
  one_test ./ecrase tutu $fic_inexistant 2
  echo -n "Running ./ecrase on existing file... "
  one_test ./ecrase tutu $fic_existant 0 tutu
  echo -n "Running ./ecrase on non accessible file... "
  one_test ./ecrase tutu $fic_inaccessible 1
  clean

## test cree-ou-ecrase
  init
  echo -n "Running ./cree-ou-ecrase on non existing file... "
  one_test ./cree-ou-ecrase tutu $fic_inexistant 0 tutu
  echo -n "Running ./cree-ou-ecrase on existing file... "
  one_test ./cree-ou-ecrase tutu $fic_existant 0 tutu
  echo -n "Running ./cree-ou-ecrase on non accessible file... "
  one_test ./cree tutu $fic_inaccessible 1
  clean

## test ajoute
  init
  echo -n "Running ./ajoute on non existing file... "
  one_test ./ajoute tutu $fic_inexistant 2
  echo -n "Running ./ajoute on existing file... "
  one_test ./ajoute tutu $fic_existant 0 turlututu
  echo -n "Running ./ajoute on non accessible file... "
  one_test ./cree tutu $fic_inaccessible 1
  clean

## test cree-ou-ajoute
  init
  echo -n "Running ./cree-ou-ajoute on non existing file... "
  one_test ./cree-ou-ajoute tutu $fic_inexistant 0 tutu
  echo -n "Running ./cree-ou-ajoute on existing file... "
  one_test ./cree-ou-ajoute tutu $fic_existant 0 turlututu
  echo -n "Running ./cree-ou-ajoute on non accessible file... "
  one_test ./cree tutu $fic_inaccessible 1
  clean


