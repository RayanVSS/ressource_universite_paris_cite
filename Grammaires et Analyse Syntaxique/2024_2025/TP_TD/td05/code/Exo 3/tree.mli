(* module of derivation trees *)

(* type of trees. Inner nodes are labeled with strings, *)
(* leaves are labeled with chars. *)
(* Inner nodes may have an arbitrary number of children. *)
type t =
  | Node of string * t list
  | Leaf of char

(* conversion to string *)
val to_string: t -> string

(* pretty printer for trees *)
val pretty_print_tree: t -> unit
