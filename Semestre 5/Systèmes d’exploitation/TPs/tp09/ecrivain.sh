#!/bin/bash

if [[ $# -ge 1 ]]
then
	echo $@ > echange
else
	echo -e "Une nuit au pied du mur, j’ai refusé les yeux ouverts \nce que d’autres acceptent les yeux fermés.\nMiss Tic" > echange
fi
