TP nº4 : le système de gestion des fichiers (SGF)
==========================

**L3 Informatique - Système**


Ce TP porte, d'une part, sur la consultation du contenu des inœuds, et
d'autre part, sur le parcours de répertoires.


#### Exercice 1 : consulter les caractéristiques d'un fichier à l'aide de `stat()`ou `lstat()`

_Cet exercice utilisera principalement les pages de man stat(2) et inode(7). Il sera fait usage de la notion de masque, cf. fin du cours 4. Il ne faudra pas utiliser l'option -std=c99 pour la compilation._ 

* Écrivez un programme qui teste à l'aide de (la valeur de retour de)
  `stat()` si une chaîne de caractères `ref` (passée en paramètre) est
  une référence valide.

* Modifiez le programme pour qu'il affiche le numéro d'inœud
  correspondant à `ref` (si `ref` est valide).

* Modifiez à nouveau le programme pour qu'il affiche le type de fichier
  sur lequel pointe `ref` (fichier ordinaire, répertoire, lien
  symbolique, tube nommé...). 

  Vérifiez que votre programme se comporte correctement pour les fichiers
  créés (dans le répertoire courant) par le script
  [tests_tp4.sh](tests_tp4.sh). Que pensez-vous en particulier du cas de
  `test_lien`? Changez `stat()` en `lstat()` et comparez.

* Modifiez le programme pour qu'il indique si le fichier est exécutable
  par au moins une catégorie d'utilisateurs. 

  Vérifiez que `tests_tp4.sh`, `test_rep`, `test_exe1` et `test_exe2` sont
  bien reconnus comme exécutables, contrairement à `test_fic`. Qu'en est-il
  de `test_lien` ? Corrigez si nécessaire.


#### Exercice 2 : lire les entrées d'un répertoire avec `readdir()` (ainsi qu'`opendir()` et `closedir()`)

* Écrivez un programme ayant à peu près le même comportement que `ls -a` (ou `ls -f`,
  plutôt; consultez `man ls` si nécessaire).
  On ne vous demande pas de faire de la mise en page, une sortie avec une entrée par ligne est suffisante. 

* Modifiez votre programme pour obtenir (à peu près) le comportement de
  `ls -i` (c'est-à-dire sans tri, mais aussi sans les fichiers "cachés").

* Modifiez votre programme pour lister le contenu du ou des 
  répertoires dont les noms sont passés en paramètre (s'il y en a).

* Modifiez votre programme pour afficher la taille de chaque fichier listé.


#### Exercice 3 : pwd

Le but final de cet exercice est d'écrire un programme affichant la
référence absolue du répertoire courant à l'instar de la commande
`pwd -P` (consulter `man pwd` si nécessaire), sans utiliser la fonction
`getcwd()`.

On va procéder par étapes :

* Écrivez la fonction `char *nom_du_repertoire()`  qui retourne le nom du
  répertoire courant dans une arborescence stockée sur un unique
  disque.

* Dans une arborescence complexe, i.e. avec des points de montage, tester si deux chemins référencent le même fichier nécessite de comparer à la fois les numéros d'inœud **et ceux de device**, en utilisant impérativement le numéro d'inœud fourni par `stat()` et non celui fourni par la structure `dirent`. 

   Corrigez la fonction précédente pour qu'elle marche même dans une arborescence complexe. Testez  sur lulu dans le répertoire /run; vous pouvez en profiter pour vérifier que dans ce cas-là, les numéros d'inœud fournis par `stat` et par `dirent` sont différents.

* On veut maintenant la référence absolue du répertoire courant.
Le fichier `mon_pwd.c` vous donne un squelette du programme.
Pour cela, on appliquera l'algorithme suivant :

	* initialiser un chemin `courant` à `"."` et un chemin `pwd` à `"/"`
	* chercher le nom du répertoire correspondant à `courant`
	* concaténer ce nom avec le chemin `pwd`
	* recommencer récursivement sur le répertoire parent du répertoire
      `courant`, jusqu'à ce que `courant` corresponde à la racine `/` de l'arborescence.

Une caractérisation de la racine  est qu'elle est son propre parent, c'est-à-dire 
que `.` et `..` ont donc les mêmes numéros d'inœud et de disque.

Pour simplifier, toutes les chaînes de caractères seront de taille `PATH_MAX`. Il est possible que cela occasionne quelques warnings à la compilation qu'on ignorera. On pourra bien sûr améliorer le programme dans un deuxième temps.

Testez votre programme et comparer avec le résultat de `pwd -P`. En
particulier, vérifiez qu'il fonctionne correctement sur lulu, dont
l'arborescence est constituée de plusieurs disques.

