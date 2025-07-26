(* Z -> S $
   S -> O E
   O -> [ 
   E -> iK
   K -> -E | +E | ]
 *)                 

open Tree                    
open Reader
   
exception Error of string

let rec parse_Z () =          
  let x = parse_S () in
  eat EOF; x

and parse_S () =              
  match lookahead () with
  | Ch '[' 
    ->  let x1 = parse_O () in
        let x2 = parse_E () in
        Node ("S", [x1;x2])
  | _ -> raise (Error "parsing S")

and parse_O () = failwith "students, this is your job !"

and parse_E () = failwith "students, this is your job !"
  
and parse_K () = failwith "students, this is your job !"
         
let parse () = parse_Z ()
