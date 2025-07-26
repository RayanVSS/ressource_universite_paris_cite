#! /bin/bash

mkdir test_rep
mkdir .truc_bidule
echo "ô le joli fichier" > test_fic
ln -s test_fic test_lien
mkfifo test_fifo
touch test_exe1
touch test_exe2
chmod 010 test_exe1
chmod 001 test_exe2
