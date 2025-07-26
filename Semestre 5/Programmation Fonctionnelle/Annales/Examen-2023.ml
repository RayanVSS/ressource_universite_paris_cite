(* Elements de corrections pour l'examen PF5 de janvier 2023.

   Attention! Ce qui suit sont *des* réponses possibles, il peut
   évidemment en avoir d'autres. Et il est très fortement conseillé
   d'essayer de coder ses propres réponses (éventuellement avec un ordi
   et un OCaml) *avant* de comparer avec ce qui suit. Il n'y a que
   comme ça qu'un corrigé peut vraiment aider, pas en apprenant par coeur
   des bouts de code qui ne resserviront jamais à l'identique.

   Les "let _ = ..." sont des tests,  ils n'étaient évidemment pas demandé
   lors de l'examen.
*)

(* Exo 2 *)

let comp_gauche = function
 | x::y::l -> x+y :: l
 | l -> l

let _ = comp_gauche [1;2;3]

let rec comps_gauches = function
 | [] -> [[]]
 | [x] -> [[x]]
 | l -> l::(comps_gauches (comp_gauche l))

let _ = comps_gauches [1;2;0;4]

let rec comps l = match l with
  | []  -> [[]]
  | [_] -> [l]
  | a::b::l' ->
    (List.map (fun l -> a::l) (comps (b::l')))@
      (comps ((a + b)::l'))

let _ = comps [1;1;1;1]

(* Exo 3 : Mots bien parenthésés (m.b.p.) *)

type parenthese = PO | PF (* Parenthèse Ouvrante, Parenthèse Fermante *)
type mot = parenthese list
let exemple1 = [PO;PO;PF;PF;PO;PF]  (* mot (())() , bien parenthésé *)
let exemple2 = [PO;PF;PF;PO;PF;PO]  (* mot ())()) , mal parenthésé *)

(* Enumeration de tous les mbp d'une certaine taille : *)
(* Code fourni pour l'exercice 3.1 *)

let entoure m = [PO] @ m @ [PF]
let rec sigma n f = if n <= 1 then [] else sigma (n-1) f @ f (n-1)
let rec apps f l1 l2 = match l1 with
  | [] -> []
  | x1::r1 -> (List.map (f x1) l2) @ (apps f r1 l2)
let rec mbps = function
  | 0 -> [[]]
  | 1 -> []
  | n -> List.map entoure (mbps (n-2))
         @ sigma n (fun k -> apps (@) (mbps k) (mbps (n-k)))
let test_mbp m = List.mem m (mbps (List.length m))

(* fin code fourni *)

let _ = mbps 6;;
let _ = test_mbp exemple1;;
let _ = test_mbp exemple2;;

(* 3.2 : Caractérisation des m.b.p. *)

(* Version suivant directement la définition: *)

let rec ouverture = function
  | [] -> 0
  | PO::l -> 1 + ouverture l
  | PF::l -> -1 + ouverture l

let rec prefixes = function
  | [] -> [[]]
  | x::l -> [] :: List.map (fun u -> x::u) (prefixes l)

let _ = prefixes exemple1;;

let test_mbp_opt l =
 ouverture l = 0 && List.for_all (fun u -> ouverture u >=0) (prefixes l)

let _ = test_mbp_opt exemple1
let _ = test_mbp_opt exemple2

(* Version "bonus" : passage unique dans l (et accessoirement
  tail-recursif, de complexité linéaire, sans allocation memoire) *)

let rec test_mbp_tl lvl = function
  | [] -> lvl = 0
  | PO::l' -> test_mbp_tl (lvl+1) l'
  | PF::l' -> lvl > 0 && test_mbp_tl (lvl-1) l'

let test_mbp_opt l = test_mbp_tl 0 l

let _ = test_mbp_opt exemple1
let _ = test_mbp_opt exemple2


(* Type symbolique décrivant précisément les m.b.p. *)

type mbp =
  | Vide
  | Paren of mbp
  | Concat of mbp * mbp

(* 3.3 *)

let rec ecrire_mbp = function
  | Vide -> []
  | Paren m -> [PO] @ ecrire_mbp m @ [PF]
  | Concat (m1,m2) -> ecrire_mbp m1 @ ecrire_mbp m2

(* 3.4 *)

let rec lecture pile mot =
  match mot, pile with
  | [], [s] -> s
  | [], _ -> failwith "Unexpected end of word"
  | PO::mot, _ -> lecture (Vide::pile) mot
  | PF::mot, cur::last::pile -> lecture ((Concat (last,Paren cur))::pile) mot
  | PF::mot, _ -> failwith "Unexpected closing"

let lire_mbp mot = lecture [Vide] mot

(* NB : ci-dessus, on peut rajouter un cas particulier gérant cur=Vide
   pour éviter des Concat(Vide,...) superflus *)

let _ = lire_mbp exemple1
(* let _ = lire_mbp exemple2 *)


(* Ce type mbp n'est pas canonique :
  - Concat(Vide,s) \approx s \approx Concat(s,Vide)
  - Concat(Concat(..,..),..) \approx Concat(..,Concat(..,..))
  Normalisons...
*)

(* 3.5 *)

let rec concats = function
  | [] -> Vide
  | [p] -> p
  | p::ps -> Concat (p, concats ps)

(* 3.6 *)

let rec aplatir m = match m with
  | Vide -> []
  | Paren _ -> [m]
  | Concat (m1,m2) -> aplatir m1 @ aplatir m2

(* 3.7 *)

let rec normalize m =
  aplatir m
  |> List.map (function Paren m -> Paren (normalize m) | _ -> assert false)
  |> concats

let _ = lire_mbp exemple1 |> normalize


(* 3.8 Version canonique du type mbp *)

type mbpcan = atom list
and atom = Paren of mbpcan
