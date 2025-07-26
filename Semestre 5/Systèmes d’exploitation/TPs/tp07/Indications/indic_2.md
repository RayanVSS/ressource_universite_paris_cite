_**Indication** : le but est d'obtenir  **de façon certaine** un affichage du type :_
```
  Mange tes épinards!
  Non!
  Non!
  [...]
  Non!
  Oui pôpa...
  C'est bien, Popeye! Tu seras fort comme papa.
```
_(sans temps d'attente avant la dernière ligne)._

_Pour obtenir ce résultat, la première ligne doit impérativement être
affichée avant l'appel à `fork`, et la dernière ligne après un appel
(bloquant) à `wait`._

_Si les affichages sont réalisés en appelant directement `write`, il ne
peut pas y avoir de mauvaise surprise. En revanche, en cas d'utilisation
de `printf`, les écritures sont a priori différées et groupées pour
limiter le nombre d'appels à `write`. Si le tampon de `stdout` n'est pas
vidé avant le `fork`, le fils en hérite, et l'affichage devient alors :_
```
  Mange tes épinards!
  Non!
  Non!
  [...]
  Non!
  Oui pôpa...
  Mange tes épinards!
  C'est bien, Popeye! Tu seras fort comme papa.
```
_où toutes les premières lignes correspondent à l'affichage du fils, et
les deux dernières à celui du père._
