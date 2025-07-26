#!/bin/bash

echo_red() {
  if [ -t 1 ] && command -v tput >/dev/null 2>&1 
  then
    echo -n "$(tput setaf 1)$(tput bold)" 2>/dev/null
    echo $@
    echo -n "$(tput sgr0)" 2>/dev/null
  else
    echo $@
  fi
}
echo_yellow() {
  if [ -t 1 ] && command -v tput >/dev/null 2>&1 
  then
    echo -n "$(tput setaf 3)$(tput bold)" 2>/dev/null
    echo $@
    echo -n "$(tput sgr0)" 2>/dev/null
  else
    echo $@
  fi
}

SUCCESS=true

echo_yellow -e "Testing findp (exercise 2)\n"

if ! make --no-print-directory findp; then
  exit 1
fi

echo -n "Running ./findp . key... "

if ./findp . key >/dev/null 2>&1; then
    echo "OK"
else
    echo_red -n "Failed"
    echo ": File key not found"
    SUCCESS=false
fi

echo -n "Running ./findp tests NONEXISTENT... "

rm -f tests/NONEXISTENT
if ./findp tests NONEXISTENT >/dev/null 2>&1; then
    echo_red -n "Failed"
    echo ": Should have exited with EXIT_FAILURE"
    SUCCESS=false
else
    echo "OK"
fi

if $SUCCESS; then
   if command -v valgrind >/dev/null 2>&1; then
     echo -n "Running \`valgrind --leak-check=full ./findp . egg\` ... "
     valgrind --leak-check=full --error-exitcode=33 \
	      ./findp . egg >/dev/null 2>&1
     RES=$?
     if [ "$RES" -eq 33 ]; then
       echo_red "Failed"
       SUCCESS=false
     else
       echo "OK"
     fi
   else
     echo \
       "Could not  run memory leaks check: please install valgrind on this computer if you can, otherwise ignore this line."
   fi
fi



if ! $SUCCESS; then
  exit 1
fi
