#!/bin/bash

SUCCESS=true


echo_red() {
  if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    echo -n "$(tput setaf 1)$(tput bold)" 2>/dev/null
    echo $@
    echo -n "$(tput sgr0)" 2>/dev/null
  else
    echo $@
  fi
}

echo -n 'Running `echo "Hello, world!" | ./my-dd`... '
echo "Hello, world!" | ./my-dd >/dev/null 2>&1
RES=$?
cmp --silent <(echo "Hello, world!" | ./my-dd) <(echo "Hello, world!")
OUT=$?
if [ $RES -eq 0 -a $OUT -eq 0 ]; then
    echo "OK"
else
    SUCCESS=false
    echo_red "Failed"
fi
if [ $RES -ne 0 ]; then
    echo " - Expected exit code 0, got $RES"
fi
if [ $OUT -ne 0 ]; then
    echo " - Expected output:"
    echo "Hello, world!"
    echo " - Actual output:"
    echo "Hello, world!" | ./my-dd
fi




echo -n 'Running `./my-dd -i NONEXISTENT_FILE`... '
rm -rf NONEXISTENT_FILE
./my-dd -i NONEXISTENT_FILE </dev/null >/dev/null 2>&1
RES=$?
if [ $RES -eq 1 ]; then
    echo "OK"
else
    echo_red "Failed"
    echo " - Expected exit code 1, got $RES"
fi




echo -n 'Running `echo "Hello, world!" | ./my-dd -o NONEXISTENT_FILE`... '
rm -rf NONEXISTENT_FILE
TMP=$(mktemp)
echo "Hello, world!" | ./my-dd -o NONEXISTENT_FILE > "$TMP" 2>&1
RES=$?
cmp --silent <(echo "Hello, world!") NONEXISTENT_FILE >/dev/null 2>&1
CONTENTS=$?
cmp --silent <(echo -n "") "$TMP" >/dev/null 2>&1
OUT=$?
df -Th . | grep drvfs >/dev/null 2>&1 # WSL seems to ignore mode argument in open(). No time to
WSL=$?                                # figure out what is going on, so just skip the permissions test on WSL
if [ $RES -eq 0 -a -f NONEXISTENT_FILE -a \
          \( $WSL -eq 0 -o \
          \( -r NONEXISTENT_FILE -a -w NONEXISTENT_FILE -a ! -x NONEXISTENT_FILE \) \) \
     -a $CONTENTS -eq 0 -a $OUT -eq 0 ]; then
    echo "OK"
else
    SUCCESS=false
    echo_red "Failed"
fi
if [ $RES -ne 0 ]; then
    echo " - Expected exit code 0, got $RES"
fi
if [ ! -f NONEXISTENT_FILE ]; then
    echo " - Did not create the file"
else                                      
    if [ $WSL -ne 0 -a ! \( -r NONEXISTENT_FILE -a -w NONEXISTENT_FILE -a ! -x NONEXISTENT_FILE \) ]; then
        echo " - Created a file with wrong permissions (should be readable and writable, but not executable, by the current user)"
    fi
    if [ $CONTENTS -ne 0 ]; then
        echo " - Wrong output file contents, expected:"
        echo "Hello, world!"
        echo " - Actual:"
        cat NONEXISTENT_FILE
    fi
    if [ $OUT -ne 0 ]; then
        echo " - Should not have written anything on either stdout or stderr. Wrote:"
        cat "$TMP"
    fi
fi
rm -rf NONEXISTENT_FILE "$TMP"



echo -n 'Running `echo "Hello, world!" | ./my-dd -b 2 -c 5`... '
echo "Hello, world!" | ./my-dd -b 2 -c 5 >/dev/null 2>&1
RES=$?
cmp --silent <(echo "Hello, world!" | ./my-dd -b 2 -c 5) <(echo -n "Hello, wor")
OUT=$?
if [ $RES -eq 0 -a $OUT -eq 0 ]; then
    echo "OK"
else
    SUCCESS=false
    echo_red "Failed"
fi
if [ $RES -ne 0 ]; then
    echo " - Expected exit code 0, got $RES"
fi
if [ $OUT -ne 0 ]; then
    echo " - Expected output:"
    echo "Hello, wor[EOF]"
    echo " - Actual output:"
    echo "Hello, world!" | ./my-dd -b 2 -c 5
    echo "[EOF]"
fi



if $SUCCESS; then
    echo -n 'Running `./my-dd -i <10MB file> -o <Empty file> -b 1MB`... '
    TMP_IN=$(mktemp)
    TMP_OUT=$(mktemp)
    TMP_STD=$(mktemp)
    dd if=/dev/urandom "of=$TMP_IN" bs=1MB count=10 >/dev/null 2>&1
    ./my-dd -i "$TMP_IN" -o "$TMP_OUT" -b 1MB > "$TMP_STD" 2>&1
    RES=$?
    cmp --silent "$TMP_IN" "$TMP_OUT" >/dev/null 2>&1
    CONTENTS=$?
    cmp --silent <(echo -n "") "$TMP_STD" >/dev/null 2>&1
    OUT=$?
    if [ $RES -eq 0 -a $CONTENTS -eq 0 -a $OUT -eq 0 ]; then
        echo "OK"
    else
        SUCCESS=false
        echo_red "Failed"
    fi
    if [ $RES -ne 0 ]; then
        echo " - Expected exit code 0, got $RES"
    fi
    if [ $CONTENTS -ne 0 ]; then
        echo " - Wrong output file contents"
    fi
    if [ $OUT -ne 0 ]; then
        echo " - Should not have written anything on either stdout or stderr"
    fi
    rm "$TMP_IN" "$TMP_OUT" "$TMP_STD"
fi



if command -v valgrind >/dev/null 2>&1; then
    echo -n "Running \`dd if=/dev/urandom bs=1024 count=1024 | valgrind --leak-check=full ./my-dd\`... "
    dd if=/dev/urandom bs=1024 count=1024 2>/dev/null |\
        valgrind --leak-check=full --error-exitcode=33 ./my-dd >/dev/null 2>&1
    RES=$?
    if [ "$RES" -eq 33 ]; then
        echo_red "Failed"
    else
        echo "OK"
    fi

    echo -n "Running \`dd if=/dev/urandom bs=1024 count=1024 | valgrind --leak-check=full ./my-dd -o /dev/full\`... "
    dd if=/dev/urandom bs=1024 count=1024 2>/dev/null |\
        valgrind --leak-check=full --error-exitcode=33 ./my-dd -o /dev/full >/dev/null 2>&1
    RES=$?
    if [ "$RES" -eq 33 ]; then
        echo_red "Failed"
    else
        echo "OK"
    fi

else
    echo "Could not run memory leaks check: please install valgrind on this computer if you can, otherwise ignore this line."
fi

