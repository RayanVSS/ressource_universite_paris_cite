_**Indication** : il s'agit de préparer le processus pour que l'instruction
  `execlp("cat", "cat", NULL)` réalise la copie souhaitée; comme `cat`
  recopie sur `STDOUT_FILENO` ce qu'elle lit sur `STDIN_FILENO`, il faut
  donc rediriger l'entrée standard vers `fic1`, et la sortie standard sur
  `fic2`. Chaque redirection est obtenue par une duplication de
  descripteur -- il faut donc un descripteur (en lecture) pour `fic1`, et
  un descripteur (en écriture) pour `fic2`. Il faut donc, dans l'ordre :_

  * _ouvrir les deux fichiers concernés dans le mode adéquat;_
  * _dupliquer les deux descripteurs obtenus vers `STDIN_FILENO` et `STDOUT_FILENO`;_
  * _fermer les descripteurs devenus inutiles;_
  * _faire l'`exec`._

