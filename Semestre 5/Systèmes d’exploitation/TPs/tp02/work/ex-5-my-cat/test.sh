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

for f in input-*.txt; do
  echo -n "Running ./my-cat on $f... "
  if ./my-cat < "$f" | cmp --silent - "$f"; then
    echo "OK"
  else
    SUCCESS=false
    echo_red -e "Failed\n"
    echo "Expected output:"
    cat "$f"
    echo -e "[EOF]\n"
    echo "Actual output:"
    ./my-cat < "$f"
    echo -e "[EOF]\n"
  fi
done

if $SUCCESS; then
  TMP1=$(mktemp)
  TMP2=$(mktemp)
  dd if=/dev/urandom of=$TMP1 bs=1024 count=10240 2> /dev/null
  echo -n "Running ./my-cat on a larger input (10MiB)... "
  TIME=$({ time ./my-cat < "$TMP1" > "$TMP2" ; } 2>&1 | grep real | cut -f2)
  if cmp --silent "$TMP1" "$TMP2"; then
    echo "OK (in $TIME)"
  else
    echo_red "Failed"
  fi
  rm -f "$TMP1" "$TMP2"
fi

if command -v valgrind >/dev/null 2>&1; then
    echo -n "Running \`dd if=/dev/urandom bs=1024 count=1024 | valgrind --leak-check=full ./my-cat\`... "
    dd if=/dev/urandom bs=1024 count=1024 2>/dev/null |\
        valgrind --leak-check=full --error-exitcode=33 ./my-cat >/dev/null 2>&1
    RES=$?
    if [ "$RES" -eq 33 ]; then
        echo_red "Failed"
    else
        echo "OK"
    fi
else
    echo "Could not run memory leaks check: please install valgrind on this computer if you can, otherwise ignore this line."
fi

