
type token =
  DIGIT of int | OTHER | EOF


let to_string = function
    DIGIT i -> "DIGIT "^(string_of_int i)
  | OTHER -> "OTHER"
  | EOF -> "EOF"
              
