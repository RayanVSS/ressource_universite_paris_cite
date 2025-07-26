(* module for LL(1) parser *)

(* parsing error *)
exception Error of string

(* principal parsing function *)
val parse: unit -> Tree.t
                     
