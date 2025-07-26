
(* Ensembles OCaml via Set.Make *)

(* user : un exemple de type sur lequel on veut former des ensembles.
   Le "mutable" ci-dessous n'est pas important au début, il servira
   ultérieurement à montrer les dangers de l'impératif en présence
   d'ensembles. *)

type user = { mutable uid : int; name : string }

(* Exemple de fonction de comparaison sur le type user, ici en
   ne comparant que les champs uid *)
let compare_user u u' = Stdlib.compare u.uid u'.uid

let a = { uid = 2; name = "foo" }
let b = { uid = 3; name = "bar" }
let c = { uid = 5; name = "baz" }

(* Ensembles sur le type user *)

module USet =
  Set.Make (struct
      type t = user
      let compare = compare_user
    end)

let ex = USet.add a (USet.add b (USet.add c USet.empty))
(* L'ensemble ex est de type USet.t *)

(* Autre manière de créer ce même ensemble *)
let ex = USet.of_list [a;b;c]

(* Quelques opérations possibles *)
let _ = USet.mem b ex;; (* recherche (dichotomique, logarithmique) *)
let _ = USet.cardinal ex;; (* taille de ex *)
let _ = USet.elements ex;; (* conversion vers des listes (triées) *)

(* Vu le choix de compare_user, impossible d'avoir dans un ensemble
   deux user de même uid (mais des champs "name" différents).
   Par contre, cela serait possible avec "let compare = Stdlib.compare"
   mis dans la définition de USet ci-dessus
*)

let _ = USet.elements (USet.add { uid = 2; name = "oof" } ex);;
(* Rien n'est ajouté en fait, il y a déjà dans ex quelqu'un d'égal
   (au sens de compare_user) à { uid = 2; name = "oof" }, c'est b *)


(* /!\ Attention : Actions impératives et ensembles.

   En bref : si on "mute" certaines données en place, on peut casser
   la recherche dans un USet.t !

   En effet, un USet.t est en interne un arbre binaire de recherche
   (plus précisément un arbre AVL), avec donc des invariants forts
   sur l'ordre de ses éléments aux différents noeuds). Il ne faut donc
   pas modifier impérativement une donnée dès qu'elle est stockée dans
   un ensemble. En tout cas rien qui changement la comparaison utilisée
   entre les éléments. Ceci n'est pas spécifique aux Set d'OCaml,
   on peut faire le même genre de blagues avec des Hashtbl, ou tout
   autre conteneur ayant des invariants forts qu'une mutation impérative
   remettrait en cause.
*)

(* Au début a,b,c sont dans ex, tout va bien *)
let _ = (USet.mem a ex, USet.mem b ex, USet.mem c ex);;

b < c;;

(* Modifions c.uid *)
c.uid <- 1;;

b < c;;

let _ = (USet.mem a ex, USet.mem b ex, USet.mem c ex);;
(* Alors a et b sont bien dans ex, mais plus c ! *)

(* Explication. L'exemple ex précédent est en fait ici l'arbre suivant:

   a
  / \
     b
    / \
       c
      / \

Après le changement impératif de c.uid, on a maintenant c < b donc la
recherche dichotomique de c lors du (USet.mem c ex) ira chercher dans
le fils *gauche* b, qui est vide, et non plus à droite comme avant. *)

c.uid <- 5;; (* retour à la situation de départ *)

a.uid <- 6;; (* autre essai de mutation impérative *)

let _ = (USet.mem a ex, USet.mem b ex, USet.mem c ex);;
(* Maintenant il n'y a plus que a dans ex, mais ni b ni c !
   Même explications, maintenant b < a et c < a, donc b et c
   sont cherchés à gauche de a, qui est vide. *)


(* Deux remarques complémentaires :

- Par rapport aux AVL "de la littérature", ceux d'OCaml peuvent
  surprendre : à chaque noeud, la différence entre profondeur gauche
  et profondeur droite est d'au plus 2, au lieu de 1 souvent ailleurs.

- Comment retrouver cette forme interne de la valeur ex alors que
  OCaml n'affiche que <abstr> ? On peut utiliser une fonction
  "interdite" d'OCaml nommée Obj.magic, qui "triche" avec les types.
  Attention danger, en cas d'erreur on crashe toute sa session OCaml.
  Par exemple ici, accès aux fils gauche, droit et à la racine de ex :

let (g,root,d,_) = (Obj.magic ex : (USet.t * user * USet.t * int));;

  Ne pas utiliser Obj.magic (ni rien du module Obj) dans un véritable
  programme.
*)
