(* module for a lookahead(1) reader from standard input*)

exception Error of string

(* a token is a character, or the end-of-file marker *)
type token = Ch of char | EOF

(* return the next token, do not advance the read pointer *)
val lookahead : unit -> token

(* [(eat t)] advances the read pointer if the next *)
(* token is t and throws an Error otherwise. *)
val eat : token -> unit
