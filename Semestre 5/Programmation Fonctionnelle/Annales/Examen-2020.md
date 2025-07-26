Correction de l'examen PF5 2019-2020
===================================

[Sketch link](https://sketch.sh/s/0GtYZ1sYDhsVBigFAEZUDg)

[Le sujet](examen1920.pdf)

Ce sujet a été écrit par Yann Régis-Gianas.
Corrigé par Pierre Letouzey.

## Exercice 1 (Des expressions et des types)

Plus de détails dans la séance du [cours 11 sur le typage](../slides/cours-11-typage.ml) (26/11/2020).
Pour le corrigé des premières questions, il suffit de demander à OCaml:

```ocaml
fun x -> x + 1;;
(* - : int -> int = <fun> *)
fun x -> (x, x);;
(* - : 'a -> 'a * 'a = <fun> *)
fun x y -> Some (x, y);;
(* - : 'a -> 'b -> ('a * 'b) option = <fun> *)
(fun x -> (x, x)) 0;;
(* - : int * int = (0, 0) *)
(fun x y -> (x, y)) 0 1;;
(* - : int * int = (0, 1) *)
(fun x y -> (x, y)) 0;;
(* - : '_a -> int * '_a = <fun> *)
fun f x y -> f y x;;
(* - : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c = <fun> *)
```

Dans l'avant-dernière phrase, notez les soulignés : `'_a` au lieu de `'a`. Cela signifie que cette variable de type n'est pas généralisée. Voir le cours pour plus de détails. Une réponse sans les soulignés était déjà satisfaisante ici.

Ensuite, voici quelques exemples d'expression OCaml ayant les types demandés. Il y en a évidemment beaucoup d'autres! Notez l'usage des additions pour restreindre certains types à `int`. La dernière ligne est une forme de composition de fonctions.

```ocaml
fun (a,b) -> (a+1,b+1);;
(* - : int * int -> int * int = <fun> *)
fun f x -> x + f 0;;
(* - : (int -> int) -> int -> int = <fun> *)
fun f g x -> g (f x);;
(* - : ('a -> 'b) -> ('b -> 'c) -> 'a -> 'c = <fun> *)
```

## Exercice 2 (Corrections de programmes)


### 2.1

Le code du sujet intervertit les réponses `d` et `v`. OCaml signale une erreur à la dernière ligne vu que `v` y est indéfini. Le message d'erreur précis est `Error: Unbound value v` (on ne vous demandait pas les mots exacts de cette erreur, mais l'idée générale). Code corrigé :

```ocaml
let default d o =
match o with
| Some v -> v
| None -> d
;;
```

### 2.2

Syntaxe et typage correct, même si le compilateur signale que le cas des listes à un unique élément n'est pas géré : `Warning: this pattern-matching is not exhaustive`. Ceci dit, un "warning" n'est pas compté comme une erreur detectée par le compilateur ici. Par contre ce code n'implémente pas correctement sa spécification : `is_sorted [1]` répondra `Exception: Match_failure` au lieu de `true`. Un deuxième souci avec ce code : il peut aussi répondre `true` sur une liste non triée, par exemple `[1;2;1]`. En effet l'appel récursif enlève *deux* éléments de la liste à chaque fois, on ne vérifie donc pas si `b` est bien inférieur aux éléments de `l`. Code corrigé :

```ocaml
(* version basique *)
let rec is_sorted l = match l with
| [] -> true
| [_] -> true
| a :: b :: l -> a < b && is_sorted (b::l)

(* un peu plus avancé : on évite de recréer une liste b::l et 
   on factorise les deux premiers cas : *)
let rec is_sorted = function
| [] | [_] -> true
| a :: ((b :: l) as l') -> a < b && is_sorted l'
```

### 2.3

Si on donne le code de l'énoncé à OCaml, on obtient une erreur de typage ... à la dernière ligne, sur le `a` final !

```
Error: This expression has type 'a but an expression was expected of type 'a list
```

Voyons d'où vient ce message d'erreur. Le premier moment intéressant lors du typage de cette phrase est `(add b bs)`. Ici
`b::bs` est une liste donc `bs` aussi et `b` a un type compatible avec les éléments de cette liste `bs`. Donc `add` sera vu par OCaml comme ayant un type `'a -> 'a list -> ...`. Cela n'est pas compatible avec la spécification demandée (`add : 'a -> 'a -> 'a`). Mais OCaml ne connaît pas cette spécification (pas d'annotation de typage sur `add` et `zero`) donc le typage de la phrase continue. Le `add a (add b bs)` montre alors que le type de retour du `add` est aussi le type de son second argument. Bref `add : 'a -> 'a list -> 'a list`, et cette deuxième branche du `function` répond donc un `'a list`. Cela ne pose pas de souci avec la première branche du `function` : OCaml pense juste que `zero` a le type `'a list` (ce qui ne satisfait pas la spécification prévue, mais c'est une autre histoire). Par contre on ne peut pas avoir ce type `'a list` comme réponse de la dernière ligne alors que `a` est un élément de la liste d'entrée, donc de type `'a`. D'où l'erreur de typage mentionnée ci-dessus.

Code corrigé :

```ocaml
let rec reduce add zero = function
| [] -> zero
| a :: b :: bs -> add a (reduce add zero (b::bs))
| [a] -> a
```

On m'avait aussi proposé le correctif suivant, qui type bien, mais ne se comportera correctement que si `add x zero = x`, ce qui n'était pas précisé par l'énoncé, et donc potentiellement invalide. Oui la fonction `add` peut en fait être une multiplication quand `reduce` sera utilisé, et une variable nommée `zero` ne sera pas forcément lancé avec 0.

```
(* Legerement incorrect *)
let rec reduce add zero = function
| [] -> zero
| a :: b :: bs -> add a (add b (reduce add zero bs))
| [a] -> a

let _ = reduce ( * ) 0 [1;2]
(* répond 0 alors que le code précédent répond 2 *) 
```

### 2.4

Pas d'erreur de syntaxe ni de typage. Par contre la spécification demandant des `x <> y` n'est pas respectée, et les couples `(x,y)` tels que `x + y <= n` sont ignorés alors qu'on veut au contraire les collecter. Code corrigé :

```ocaml
let combine choices f = List.flatten (List.map f choices);;
let all_addition l n =
combine l (fun x ->
combine l (fun y ->
if x <> y && x + y <= n then [(x, y)] else []
))

let _ = all_addition [1;2] 5
```

## Exercice 3 (Récursion terminale)

```ocaml
let rec filter p l =
match l with
| [] -> []
| x :: xs -> if p x then x :: filter p xs else filter p xs
```

1. `p` a le type `'a -> bool` (où `'a` est le type des éléments de la liste `l`).
2. `('a -> bool) -> 'a list -> 'a list`
3. Dans le cas du `then`, le résultat de l'appel récursif `filter p xs` est retravaillé en y ajoutant `x` devant : c'est donc un appel récursif en position non-terminale, et donc ce codage de `filter` n'est pas récursif terminal.
4. 

```ocaml
let filter' p l =
  let rec loop acc = function
   | [] -> List.rev acc
   | x :: xs -> if p x then loop (x::acc) xs else loop acc xs
  in loop [] l
```

Le `List.rev` ci-dessus est facultatif, pour les puristes voulant garder l'ordre même si cela n'était pas exigé par le sujet. 

## Exercice 4 (Problème : Différentes implémentations des séquences)

### 4.1

```ocaml
let destruct = function
  | [] -> None
  | x::l -> Some (x,l)
let cons x l = x :: l
let empty = []
let rec concat l1 l2 =
  match l1 with
  | [] -> l2
  | x1::l1 -> x1 :: (concat l1 l2)
let rec map f = function
  | [] -> []
  | x::l -> f x :: map f l
(* ou bien `let concat l1 l2 = l1 @ l2` et `let map = List.map`
   cela n'avait pas l'air interdit... *)
```

### 4.2

- La complexité de `concat l1 l2` est `O(length(l1))`, c'est-à-dire proportionnelle à la longueur de `l1`.
- La complexité de `map f l` est aussi linéaire (en la longueur de `l`). Comme le coût de chaque calcul `f x` individuel ne dépend pas de la longeur de `l`, on compte ici le coût de chacun de ses calculs comme constant (`O(1)`).
- Enfin `destruct l` prend un temps constant : `O(1)`.

### 4.4

```ocaml
type 'a t =
| Empty                 (* La séquence vide. *)
| Single of 'a          (* La séquence formée d'un unique élément. *)
| Concat of 'a t * 'a t (* La séquence formée d'une séquence suivie d'une autre. *)

let rec destruct = function
  | Empty -> None
  | Single x -> Some(x,Empty)
  | Concat(t1,t2) ->
     match destruct t1 with
     | None -> destruct t2
     | Some (x,t1') -> Some (x,Concat (t1',t2))

let empty = Empty

(* Solutions simples pour `cons` et `concat` : *)

let cons x t = Concat (Single x, t)
let concat t1 t2 = Concat (t1,t2)

(* Mieux : empêcher de mettre des `Empty` dans les `Concat`.
   Cela n'était pas demandé, mais cela simplifie l'analyse de la complexité
   de `destruct` et des autres fonctions *)

let cons x = function Empty -> Single x | t -> Concat (Single x, t)
let concat t1 t2 =
  match t1, t2 with
  | Empty,_ -> t2
  | _,Empty -> t1
  | _ -> Concat (t1,t2)

let rec map f = function
  | Empty -> Empty
  | Single x -> Single (f x)
  | Concat (t1,t2) -> Concat (map f t1, map f t2)
```

### 4.5

- Les deux formulations précédentes de `concat` sont de complexité `O(1)`. C'est d'ailleurs l'intérêt de cette représentation des séquences : la concaténation est instantanée. Inconvénient par rapport à une liste à la OCaml : l'accès à la tête de la liste n'est plus forcément instantané, voir `destruct` ci-dessous.
- L'expression `map f t` fait une visite complête de l'arbre `t`. Donc `map` a une complexité `O(size(t))` si `size(t)` est le nombre de noeuds `Concat` dans `t`. Là encore, on a considéré ici que chaque appel à `f` prend un temps `O(1)`.
- L'expression `destruct t` visite la structure de `t` par la gauche jusqu'à trouver une première feuille `Single`, puis "recolle" ce qui reste à droite avec des `Concat`. Dans le cas le pire, sans aucun `Single` ou alors tout en bas à droite, mais que des `Concat` et des `Empty` avant cela, la visite de `t` va être complète. Donc `destruct` a une complexité en pire cas de `O(size(t))` où `size(t)` compte le nombre de noeuds `Concat` dans `t`.

Les réponses précédents sont ce qu'on peut dire en général, sans plus d'information sur les arbres qu'on manipule. En particulier, la présence possible de feuilles `Empty` fait qu'on peut avoir des arbres arbitrairement plus gros (en noeuds `Concat`) que le nombre d'éléments qu'ils contiennent (c'est-à-dire le nombre de feuilles `Single` dedans). Si par contre on s'arrange pour n'insérer aucun `Empty` dans des `Concat`, ce qui est possible quasiment sans surcoût (cf. les secondes versions de `cons` et `concat` en 4.4),
on retrouve alors le cas bien connu des arbres binaires à données aux feuilles, et dans ce cas le nombre d'éléments d'un arbre est `1+size(t)` si `size(t)` compte le nombre de `Concat` dans `t`. Et dans ce cas, `map` et `destruct` sont linéaires en le nombre d'élements dans les arbres manipulés.

### 4.6

```ocaml

type 'a t =
| Empty                       (* La séquence vide. *)
| Cons of 'a * (unit -> 'a t) (* Un élément puis la suite est obtenue en appliquant une fonction. *)

let destruct = function
  | Empty -> None
  | Cons (x,next) -> Some (x, next())

let empty = Empty

let cons x t = Cons (x,fun () -> t)

let rec concat t1 t2 =
  match t1 with
  | Empty -> t2
  | Cons (x,next) -> Cons (x,fun () -> concat (next ()) t2)

let rec map f = function
  | Empty -> Empty
  | Cons (x,next) -> Cons (f x,fun () -> map f (next ()))
```


### 4.7

Avec la fonction `concat` précédente, le calcul de l'expression `concat t1 t2` se déroule en temps constant : la complexité de `concat` est `O(1)` ! En effet cette fonction fait une analyse de `t1`, puis parfois une construction `Cons`, avec à droite une fonction `fun () -> ...`. Toutes ces étapes se font en temps constant, même la "création" de la fonction, qui lors de l'évaluation donnera une fermeture notant où sont `concat`, `next` et `t2`, et ce qu'il faudra faire avec tout ça quand cette fonction sera exécutée. 

Cette complexité `O(1)` pour `concat` peut sembler paradoxale pour une fonction récursive. Mais c'est typique d'une structure *paresseuse* comme ce type `'a t` : certains calculs ne sont pas fait lors de la *création* d'une structure de ce type, mais repoussé au moment où on visitera cette structure en profondeur. Par exemple le calcul de `concat (Cons(x,next)) t2` ne fait *pas* le calcul de `next()` ni l'appel récursif à `concat`, il ne fait que les préparer pour plus tard (par exemple si on fait un jour des `destruct` successifs sur cette structure). Une bonne illustration de cet aspect paresseux : on peut représenter des séquences potentiellement infinies, et même les concaténer, c'est immédiat. Par contre convertir de telles séquences en listes OCaml ne terminera jamais.

```ocaml
let rec integers_above n = Cons (n, fun () -> integers_above (n+1))
let all_integers = integers_above 0
let biinfini = concat all_integers all_integers

let rec tolist = function
|Empty -> []
|Cons(x,next) -> x :: tolist (next())

let _ = tolist all_integers (* Stack overflow *)

(* Sur de telles séquences infinies, on ne peut obtenir
   en temps fini ... qu'un fragment fini *)
 
let rec debut k t =
 if k = 0 then []
 else match t with
    |Empty -> []
    |Cons(x,next) -> x :: debut (k-1) (next())

let _ = debut 10 all_integers (* [0;1;2;3;4;5;6;7;8;9] *)

```

Pour la complexité de `map f t`, c'est la même idée que pour `concat`, à savoir `O(1)`. On considère toujours ici que chaque appel à `f` prend un temps constant.

Enfin, la complexité de `destruct t` se résume à celle de l'appel `next()` qui peut se produire si `t` est un `Cons(x,next)`. La plupart du temps cette fonction `next` aura aussi une complexité `O(1)` vis-à-vis de la taille (potentielle) de notre structure. C'est le cas par exemple si `t` a été formé via les fonctions `concat` et `map` précédentes appelées sur des séquences où `next` est aussi `O(1)`. On peut quand même concevoir des exemples (assez artificiels) où `next` coûte plus que cela. Par exemple:

```ocaml
let rec costly l = function
| [] -> Empty
| _::l -> Cons (List.length l, fun () -> costly l)

(* Chaque fonction `fun () -> costly l` à droite d'un Cons
aura lors de son calcul un coût linéaire en la taille de la
liste `l` qu'il reste à ce moment-là, à cause du List.length
qu'elle déclenche. Et ces listes `l` restantes ont des tailles
égales aux nombres d'éléments (potentiels) dans les séquences
qu'on fabrique. *) 
```

Bref, avec cette implémentation paressuse des séquences, tout est `O(1)` en pratique ... sauf d'accéder concrètement à tous les éléments d'une séquence paresseuse à la fin, par exemple pour convertir vers une liste OCaml (cf `tolist` ci-dessus) ou pour afficher les élements. Cette visite complète de la séquence revient essentiellement à répéter des `destruct` ce qui nous donne un coût linéaire en le nombre d'éléments de la séquence. 

### 4.8

La déforestation est une optimisation. On évite en effet l'allocation en mémoire de la séquence intermédiaire `map g l` qui ne sert ensuite que d'entrée à `map f`. Certes, cette séquence intermédiaire est ensuite supprimée de la mémoire par le ramasse-miette d'OCaml (GC pour Garbage Collector) vu qu'elle n'est plus utilisée. Mais on a quand même eu une consommation mémoire ponctuelle plus importante, et aussi un certain coût en temps pour la création et la suppression de cette séquence intermédiaire. Dans la version optimisée, on doit créer une fermeture `(fun x -> f (g x))` puis lancer cette fermeture sur les éléments de la séquence `l`. Cela peut être légèrement plus lent que de lancer `g` puis lancer `f`, la gestion "administrative" de la fermeture pouvant avoir un certain coût. Mais on sera normalement gagnant par rapport aux allocations/déallocations de la première écriture.

### 4.9

Pour les séquences par listes (4.1) et par arbres (4.4) le gain est clair, comme expliqué ci-dessus : pas d'allocation/déallocation de la liste ou arbre intermédiaire.

Pour les séquences paresseuses (4.6), `map` ne crée pas tout d'un coup toute une structure, mais plutôt un premier `Cons`, et le reste est disponible "à la demande". Donc l'avantage d'une déforestation est a priori moins net. `map f (map g l)` va créer deux `Cons`, dont le premier va être libérable de la mémoire tout de suite. Cette version va aussi créer deux fermetures `fun () -> ...` là où un seul
`fun () -> ...` suffit dans la version déforestée. Au final, le gain de la déforestation est moins évident dans cette verion, plus diffus,
mais il est bien là néanmoins.

