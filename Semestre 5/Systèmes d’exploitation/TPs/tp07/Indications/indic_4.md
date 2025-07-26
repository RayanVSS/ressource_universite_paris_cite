_**Indication** : contrairement à l'exercice 2, le père ne peut pas ici
se contenter de faire un appel (bloquant) à `wait`, puisqu'il doit
continuer son propre "travail" (ici, faire un affichage) tout en
cherchant à détecter la terminaison de son fils._

_Il doit donc réaliser deux opérations en boucle : l'affichage et un
`wait` non bloquant -- donc nécessairement via `waitpid` puisque `wait`
n'a pas d'option permettant de ne pas bloquer si le fils n'a pas
terminé. La boucle se termine lorsque l'appel à `waitpid` réussit._

