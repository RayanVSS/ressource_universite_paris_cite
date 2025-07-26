type program = definition list

and definition =
  | SimpleDef of identifier * term
  | RecFunction of identifier * identifier list * term

and term =
  | Var     of identifier
  | Cst     of int
  | Op      of operation
  | Let     of definition * term
  | Lam     of identifier * term
  | App     of term * term
  | Proj    of term * label
  | Record  of (label * term ) list
  | KApp    of constructor * term list
  | Match   of term * branch list

and branch = pattern * term

and pattern =
  | PVar of identifier
  | PCst of int
  | PKApp of constructor * pattern list
  | PWildcard

and identifier = Id of string

and label = LId of string

and constructor = CId of string

and operation = Add | Mul | Sub | Div
