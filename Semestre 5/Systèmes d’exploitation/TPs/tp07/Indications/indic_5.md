_**Indication** : ici le père doit utiliser à la fois la valeur de retour
précise de `wait(&wstatus)` (ou `waitpid`, mais `wait` suffit a priori)
pour déterminer quel fils a terminé, et la valeur stockée dans `wstatus`
pour déterminer la valeur de retour du fils en question (grâce aux macros
`WIFEXITED` et `WEXITSTATUS`)._

_Attention à plusieurs points importants :_

* _pour que les fils s'exécutent en parallèle et non pas en série, le
  père doit faire **deux boucles l'une après l'autre** : une pour créer
  tous les fils, et seulement ensuite une deuxième pour attendre tous 
  les fils;_

* _bien sûr, on veut 10 fils, pas 2^10 (-1) descendants;_

* _pour que les tirages soient indépendants, chaque processus doit faire
  sa propre initialisation du générateur pseudo-aléatoire, et cela avec
  un paramètre différent -- donc pas `time(NULL)`, qui s'exprime en
  secondes._
