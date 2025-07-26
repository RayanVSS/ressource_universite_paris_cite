Les fonctions en OCaml
======================

[Ancien lien Sketch](https://sketch.sh/s/XjV2RE6tIUAJkvdfQ1rgFN),
[Ancien lien Sketch](https://sketch.sh/s/tDqsDWq7jwLNCLPX3mzky7).

Auteur initial : Yann Régis-Gianas.
Modifications par : Pierre Letouzey.

## Syntaxe des fonctions

Rappel : la construction de base pour écrire une fonction est `fun x -> ...`.

Il y a ensuite de nombreuses variantes :

- `let f x = ...` est la même chose que `let f = fun x -> ...`
- `let rec f x = ...` permet la définition d'une fonction récursive.
- Une définition de fonction peut aussi être *locales* via `let ... in ...` ou `let rec ... in ...`
- Une fonction peut avoir plusieurs arguments : `fun x y z -> ...` ou `let f x y z = ...`.
  C'est un raccourci pour `fun x -> (fun y -> (fun z -> ...))`.
- Il existe également un mot-clé `function`, qui ne s'occupe que d'un unique argument
  (pas de `function x y -> ...`) mais permet par contre de commencer un *filtrage* sur
  cet argument (ou pattern matching). 
  Bref, `function ...` c'est `fun x -> match x with ...`. Par exemple :
  
```ocaml
function 0 -> "zero" | 1 -> "un" | _ -> "beaucoup";;
```

Intérêt de `function` : c'est plus concis. Pas d'obligation de s'en servir,
mais il faut savoir le comprendre quand on en rencontre. Et attention !
`function` compte toujours pour *un* argument (qui reste anonyme),
si la fonction qu'on définit en a d'autres avant, cela en fait un de
plus. Par exemple, le `map` ci-dessous a bien deux arguments en tout:

```ocaml
let rec map f = function
 | [] -> []
 | x::l -> f x :: map f l
```

## Typage

Le type d'une fonction s'écrit `t -> u` où `t` est le type de
l'argument et `u` le type du résultat.

S'il y a plusieurs arguments, cela devient `t_1 -> ... -> t_n -> u` où
`t_i` est le type du i-eme argument et `u` le type du résultat.

Le typage d'une fonction pourra être *polymorphe* : si le type d'un
argument ou du resultat n'est pas déterminé entièrement par les
contraintes liées à l'utilisation de cet argument ou de ce résultat,
OCaml utilise alors des *variables de types* `'a`, `'b`, `'c`,... pour
indiquer que tout ou partie de ce type est quelconque, et pour relier
certaines parties entre elles. Lors de l'usage de cette fonction, les
variables de types pourront être librement remplacées par n'importe
quels types.

Par exemple:

```ocaml
fun x -> x;;  (* seule contrainte : même entrée et sortie, donc 'a -> 'a *)
fun x -> x+0;; (* l'entrée subit une addition entière, et le résultat découle de cette addition, donc int -> int *)
fun x -> (x,x);; (* 'a -> 'a * 'a *)
fun x -> Some x;; (* 'a -> 'a option *)
fun x y -> Some (x, y);; (* 'a -> 'b -> ('a * 'b) option *)
fun x -> None;; (* 'a -> 'b option *)
fun f x -> f (f x);; (* ('a -> 'a) -> 'a -> 'a *)
fun f x y -> f y x;; (* ('a -> 'b -> 'c) -> 'b -> 'a -> 'c *)
fun f x y -> f x y;; (* ('a -> 'b -> 'c) -> 'a -> 'b -> 'c *)
fun f -> f 0;; (* (int -> 'a) -> 'a *)
fun f x -> 0 + f x;; (* ('a -> int) -> int *)

let rec f x = f x;; (* fonction récursive qui ne terminera jamais, type 'a -> 'b *)
```

Revoir aussi le typage de la fonction `map` vue auparavant : `('a -> 'b) -> 'a list -> 'b list`.


En fait, en OCaml une fonction à plusieurs arguments n'est qu'un
enchaînement de fonctions à un argument.  Par exemple une fonction à
deux arguments est une fonction à un argument renvoyant une fonction à
un argument.  Cela se voit déjà sur l'équivalence entre `fun x y -> ...`
et `fun x -> (fun y -> ...)`.  Cela se voit aussi au niveau des
types : `t_1 -> t_2 -> u` est la même chose que `t_1 -> (t_2 -> u)`.
Par contre `(t_1 -> t_2) -> u` est tout autre chose, à savoir une
fonction prenant une autre fonction en argument (voir les exemples
précédents).

On dit que le symbole flèche `->` *associe à droite*, alors que les
opérateurs habituels comme `+` associent plutôt à gauche
(`a+b+c = (a+b)+c`).

Cette vision "argument par argument" est essentielle. Elle explique
par exemple pourquoi la syntaxe OCaml isole chaque argument lors de
l'application de fonction : `f x y` est en fait la même chose que
`(f x) y`, avec `f` recevant ses arguments les uns après les autres.
Cela nous amène aussi à la possibilité d'une application sans tous les
arguments, ce qu'on appellera une *application partielle*.

## Application partielle 

Si `f` est définie comme une fonction à `n` arguments, rien n'oblige
de lui donner d'un seul coup tous ses arguments lors d'une
application. Si `f` reçoit strictement moins de `n` arguments, on
obtient une nouvelle fonction attendant les arguments manquants, et il
n'y a pas de calcul de déclenché pour l'instant.

```ocaml
let f x y = x * y;; (* int -> int -> int *)
f 2;; (* int -> int , bref un calcul en attente car il manque encore un argument *)
fun y -> f 2 y;; (* équivalent au précédent *)
let g = f 2;;    (* nommons cette application partielle *)
g 5;; (* g est en fait la fonction qui double son argument *)
```

L'application partielle n'est pas si fréquemment utilisée que cela,
mais elle permet en particulier de *spécialiser* une fonction en une
fonction plus particulière, en pre-fournissant les premiers arguments.

Remarque : le fait que `f 2` et `fun y -> f 2 y` soient équivalents se
généralise en une loi nommé *eta-équivalence* : pour une expression
OCaml `e` ne contenant pas la variable `x`, alors `fun x -> e x` est
équivalent à `e`.  En particulier `fun x -> f x` est équivalent à `f`
si `f` est un nom de fonction.

Enfin, que ce passe-t'il si on donne *trop* d'arguments à une fonction ? 
Cela dépend du type du résultat de cette fonction !

- S'il s'agit d'un type de base (`int`, `bool`, ...) ou d'une structure de données
  (paire, liste, ...), alors ce résultat ne peut pas être appliqué aux arguments
  surnuméraires, et on obtient une erreur de typage
  
```ocaml
let f x y = x * y;;
f 1 2 3;; (* erreur *)
```

- Par contre, si le type du résultat est une variable de type, il est
  possible que cette variable de type devienne une ou plusieurs
  flèche(s) lors de l'application, "ralongeant" ainsi le type de
  départ, et acceptant plus d'arguments.
  
```ocaml
let id = fun x -> x;;
id 3;;
id id;;
id id 3;;
id id id 3;;
```


## Fonctions sur des paires ou n-uplets

Jusqu'ici les fonctions à plusieurs arguments ont été écrites `fun x y -> ...`
ou `let f x y = ...` et utilisées via `f u v`. Comme on vient de le voir, cela
donne un type composé de flèches `... -> ... -> ...`. Mais que se passe-t'il
si dans un moment d'égarement on utilise une syntaxe à la Java/C/Python ?

```ocaml
let f (x,y) = x+y;;
f(1,2);;
```

Cela marche aussi ! Mais attention, ceci n'est plus réellement une
fonction à deux arguments. La virgule indique ici qu'on utilise des
paires OCaml. Notre fonction `f` est donc une fonction à un argument,
cet argument étant une paire d'entiers.  Une autre écriture
équivalente pour ce `f` serait `let f p = match p with (x,y) -> x+y`
ce qui illustre bien l'unique argument, et le fait qu'il est
composé. Et le type de `f` est alors `int*int -> int`. Dans le cas
général d'un `fun (x1,...,xn) -> ...` on obtient un type
`t_1 *...* t_n -> ...` indiquant un n-uplet en entrée.

D'ailleurs on a déjà vu de telles fonctions:

```ocaml
let fst (x,y) = x;;
let snd (x,y) = y;;
```

Le style `fun x y -> ...` est dit *curryfié* (en l'honneur du logicien
Haskell Curry) et le style `fun (x,y) -> ...` est dit *décurryfié*.

Ces deux styles sont incompatibles : une fonction décurryfiée
s'applique obligatoirement à un n-uplet, alors qu'une fonction
curryfiée s'applique uniquement à des arguments successifs.  En
particulier si on vous demande une fonction de type `int->int->int`,
répondre `fun (x,y)->...` est incorrect.

L'usage en OCaml est de privilégier le style curryfié `fun x y -> ...`.
En particulier toute la bibliothèque standard OCaml est écrite
ainsi (à part `fst` et `snd` évidemment). Avantage : cela évite de
devoir créer un n-uplet en mémoire à chaque application pour ensuite
accéder à chacune de ses composantes lors de l'exécution de cette
fonction.  Le style curryfié est aussi le seul à permettre facilement
l'application partielle.

Enfin, un grand classique de la programmation OCaml est d'écrire des conversions
entre les deux styles :

```ocaml
let uncurry f = fun (x,y) -> f x y (* on décurryfie la fonction curryfiée f *)
let curry f = fun x y -> f (x,y) (* on curryfie la fonction décurryfiée f *)
```


## Opérateurs

Notez que mettre des `( )` autour d'un opérateur comme `&&` ou `+` en fait une
fonction OCaml comme une autre, dite *préfixe*.

```ocaml
(&&);;
(+);;
(+) 1 2;;
( * );;  (* attention aux blancs ici, sinon OCaml croit voir un commentaire ! *)
```

Si l'on combine cela avec de l'application partielle, on peut avoir une écriture
concise de certaines fonction:

```ocaml
let double = fun x -> 2 * x;;
let double = ( * ) 2;;

let nonzero x = 0<>x;;
let nonzero = (<>) 0;;
```

## Quelques exemples utilisant des fonctions anonymes

Usage typique d'une fonction anonyme :
`List.map (fun x -> 2*x) [1;2;3]`

Equivalent:
`List.map (( * ) 2) [1;2;3]`

Ou encore `List.filter (fun x -> x<5) [1;7;2;6]`
Equivalent: `List.filter ((>) 5) [1;7;2;6]`

Autre exemple, pourquoi n'y a-t'il pas de `List.remove` fourni par OCaml ?
Car c'est `fun x l -> List.filter ((<>) x) l`.

Plus complexe : `let sum_list = List.fold_left (+) 0`.

## La composition de fonctions

Un autre grand classique...

```ocaml
let compose f g = fun x -> f (g x)
(* ou encore *)
let compose f g x = f (g x)
```

En pratique on se sert rarement d'un tel `compose` en OCaml. Par
contre du code comme `f (g x)` est très fréquent, vous êtes fortement
encouragé à décomposer le travail en multiples fonctions plus
élémentaires.

Au passage une syntaxe `f1 @@ f2 @@ ... @@ fn @@ x` permet d'écrire
`f1 (f2 (... (fn x)))` sans devoir mettre de parenthèses. Personnellement
je ne suis pas fan de ce `@@`, mais bon...

Et un autre style est de partir de l'argument puis d'enchaîner les traitements
dessus, via un autre opérateur `|>` appliquant "à l'envers", ce qui donne
`x |> fn |> ... |> f1`. Par exemple `1 |> succ` donne 2.

L'opérateur `|>` (écrit | puis > en ASCII) est maintenant disponible par défaut en OCaml.
Il est défini comme suit :
```ocaml
let ( |> ) x f = f x
```
Il est associatif à gauche. Ainsi, quand on écrit `x |> f |> g |> h`,
il faut lire comme `h (g (f x))`. Il s'agit donc d'une forme de
composition, qui doit vous rappeler le *pipe* des commandes shells.




## Terminologie : fonctions de première classe

En programmation, une valeur *de première classe* peut être
utilisée sans restriction. On peut ainsi par exemple :

  - la lier à un identificateur (ou variable)
  - la passer en argument à une fonction (ou procédure)
  - la retourner comme résultat d'une fonction
  - la mettre dans des structures de données (p.ex. faire des listes de ces valeurs)
  - la comparer avec une autre valeur (du même type)

En OCaml, les fonctions sont des valeurs de première classe.

```ocaml
let bool_unary_funs = [(fun b -> b); not; (fun _ -> true); (fun _ -> false)];;
let some_bool_binary_funs = [(&&); (||); (fun b b' -> b <> b')];;
```

Seule la comparaison de fonction est limitée :

 - Le test d'égalité `=` sur les fonctions peut s'écrire, mais échoue à l'exécution
 - la comparaison physique `==` marche mais est peu utile en pratique
 
On ne peut pas non plus *sérialiser* les fonctions OCaml (cf. module `Marshal`).

Un autre exemple fabricant des listes de fonctions:

```ocaml
let lf = List.map (+) [1;2;3];; (* fonctions +1, +2, et +3 *)
(* usage de lf, par exemple: *)
List.map (fun f -> f 0) lf;;
```


## Terminologie : programmation d’ordre supérieur

Un programme est *d’ordre supérieur* s’il calcule avec des valeurs qui contiennent du code exécutable.

Oui, la POO est d’ordre supérieur : un objet, c'est un état interne + des méthodes agissant sur cet état.

La programmation fonctionnelle est aussi d’ordre supérieur (mais sans état).

Ici cet ordre supérieur va permettre d'être *modulaire* et *expressif*

## A quoi sert l'ordre supérieur ? Généralité, généralité et généralité

Le style de programmation fonctionnelle répond au problème de la
robustesse au changement en favorisant la *généralité* des composants
logiciels (plutôt que l'extensibilité du logiciel comme en POO). Alors
généralisons !

En TP, vous avez programmé une fonction `is_sorted` sur les listes d'entiers. Par exemple:
```ocaml
let rec is_sorted l = match l with
 | [] | [_] -> true
 | x :: ((y :: q) as l') -> x <= y && is_sorted l'
 
let _ = is_sorted [1;5;6]
```

Deux possibilités des `match`, au passage :

- On peut *regrouper* des motifs successifs comme `[]` et `[_]` en un seul cas
  si ces motifs déclenchent le même code (et qu'ils ont exactement les mêmes variables).
- On peut aussi nommer des portions supplémentaires d'un motif via le mot-clé `as`.
  Ceci évite de *refabriquer* un début de liste `y::q` en mémoire juste pour
  lancer l'appel récursif `is_sorted (y::q)`.

En tout cas, notez que le type inféré par OCaml est plus général que `int list -> bool`.
En fait, `is_sorted` est considéré comme *polymorphe*, et accepte toutes sortes de listes,
tant qu'on peut comparer leurs éléments avec `(<=)`. Maintenant, allons un cran plus loin :
comment utiliser cette fonction avec un ordre strict, ou un ordre décroissant ? Il faut alors
la généraliser, et en faire une fonction d'ordre supérieure recevant en plus une comparaison
booléenne :

```ocaml
let rec is_sorted_gen cmp l = match l with
 | [] | [_] -> true
 | x :: ((y :: q) as l') -> cmp x y && is_sorted_gen cmp l'
```

Notez bien le type obtenu pour `is_sorted_gen`. 

Maintenant on peut utiliser directement la fonction généralisée : 

```ocaml
let _ = is_sorted_gen (<=) [1;5;5;6]
let _ = is_sorted_gen (<) [1;5;6]
let _ = is_sorted_gen (>) [7;3;1]
```

Ou bien encore préparer une *version spécialisée* si elle revient fréquemment, souvent juste par *application partielle*:

```ocaml
let is_sorted_is_back = is_sorted_gen (<=)
```

Exercice : Au fait, que ferait ici `is_sorted_gen (<>)` ? Rappel: `<>` est le test de différence, c'est-à-dire la négation du test d'égalité `=`.
N'y aurait-il pas un lieu avec la fonction `remove_repetition` du premier cours ?

## Quelques autres exemples plus complexes 

A venir lors du prochain cours :

- comment compter avec des fonctions (et même plus de `int` !)
- comment faire des structures infinies
