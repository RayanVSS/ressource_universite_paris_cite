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

echo_yellow -e "Testing module mystring (exercise 1)\n"
if ! make --no-print-directory mystring.o; then
  exit 1
fi
if ! gcc -std=c99 -g -o tests/test-mystring tests/test-mystring.c mystring.o -ldl -rdynamic; then
  exit 1
fi

SUCCESS=true

for F in new delete append truncate; do
  echo -n "Testing string_$F()... "

  if ./tests/test-mystring "$F" >/dev/null 2>&1; then
    echo "OK"
  else
    echo_red -e "Failed"
    SUCCESS=false
  fi
done

if $SUCCESS; then
   if command -v valgrind >/dev/null 2>&1; then
     gcc -std=c99 -g -o tests/test-mystring -DSTATIC tests/test-mystring.c mystring.o
     echo -n "Running \`valgrind --leak-check=full ./tests/test-mystring\` ... "
     valgrind --leak-check=full --error-exitcode=33 \
	      ./tests/test-mystring >/dev/null 2>&1
     RES=$?
     if [ "$RES" -ne 0 ]; then
       echo_red "Failed"
       SUCCESS=false
     else
       echo "OK"
     fi
   else
     echo \
       "Could not run memory leaks check: please install valgrind on this computer if you can, otherwise ignore this line."
   fi
fi


#rm -f tests/test-mystring
rm -rf tests/test-mystring.dSYM

exec $SUCCESS
