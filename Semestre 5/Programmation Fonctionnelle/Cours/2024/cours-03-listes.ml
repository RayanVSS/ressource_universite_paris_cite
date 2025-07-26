(* Cours 3 : compléments sur les listes OCaml *)

(* Deux premières fonctions récursives *)

let rec length l =
  match l with
  | [] -> 0
  | _ :: r -> 1 + length r

let _ = length [1;2;3]

let rec sum l =
  match l with
  | [] -> 0
  | x :: r -> x + sum r

(* La longueur d'une liste est déjà accessible via une fonction
   de la bibliothèque : *)

List.length;;

(* On a aussi des fonctions d'accès à la tête et au reste d'une liste
   (i.e. tous les éléments sauf le premier). Mais attention aux exceptions
   dans le cas d'une liste vide. *)

List.hd;; (* head *)
List.tl;; (* tail *)

List.hd [1;2];;
List.hd [];;

List.tl [1;2];;
List.tl [];;

(* Style *fortement* déconseillé : utiliser List.hd et List.tl pour
   écrire une fonction récursive sur les listes. C'est moche et inefficace
   (trois analyses de l au lieu d'une seule avec un match). *)

let rec sum l =
  if l = [] then 0
  else List.hd l + sum (List.tl l);;

(* Accès au n-ieme element d'une liste.
   Attention, le coût de cette fonction est proportionnel à l'indice n,
   on n'est pas dans le cas d'un accès immédiat aux cases d'un tableau *)

List.nth;;
List.nth [1;2;3] 2;;
List.nth [1;2;3] 5;;

(* Une définition possible de cette fonction nth *)

let rec nth l n =
 match l with
 | [] -> failwith "vide"
 | x::r ->
    if n = 0 then x
    else nth r (n-1)

(* Cas particulier : accès au dernier élément d'une liste *)

let rec last l =
 match l with
 | [] -> failwith "vide"
 | [x] -> x
 | x::r -> last r;;

last [1;2;3];;
last [1];;
last [];;

(* Concaténation de deux listes : OCaml fournit l'opérateur @ *)

[1;2] @ [3;4];;

(* Et voici un codage possible de ce @ . Attention,
   le coût est proportionnel à la longueur de la 1ere liste. *)

let rec append l1 l2 =
  match l1 with
  | [] -> l2
  | x1 :: r1 -> x1 :: (append r1 l2)

(* Retirer un élément d'une liste (deux solutions équivalentes) *)

let rec remove a l =
  match l with
  | [] -> []
  | x::r ->
     let r' = remove a r in
     if x=a then r' else x::r'

let rec remove a l =
  match l with
  | [] -> []
  | x::r when x=a -> remove a r
  | x::r -> x :: remove a r

(* Toutes les listes qu'on manipule sont immutables, et donc disponibles
   à l'identique dans le futur. Ici retirer un élément, c'est créer une
   *nouvelle* liste avec un élément de moins, mais l'ancienne est toujours là.
*)

let l = [1;2;3];;
remove 2 l;;
l;;


(* Au fait, il n'y a pas que les listes d'entiers, vive le polymorphisme
   qui nous permet de faire des listes de booléens, des listes de paires,
   des listes de liste d'entiers, etc. Et les fonctions génériques précédentes
   sont toujours utilisables sur ces autres listes. Par exemple : *)

let ll = [ [1]; []; [1;2;3] ];;
remove [1] ll;;

(* Utilisation du type OCaml prédéfini nommé 'a option
   (par exemple au lieu d'une exception dans une situation sans
    réponse raisonnable). *)

let list_hd l = match l with
  | [] -> None
  | x::r -> Some x;;

(* Ensuite, il faudra analyser ce qu'il y a dans un option. Par exemple: *)

match list_hd [1;2;3] with
| None -> 0
| Some x -> x;;

(* Pour les types d'arbres, voir la fin du document du cours 2 *)
