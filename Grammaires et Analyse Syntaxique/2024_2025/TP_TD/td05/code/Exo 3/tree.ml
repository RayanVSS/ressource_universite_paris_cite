type t =
  | Node of string * t list
  | Leaf of char

let rec to_string = function
  | Node(label,[]) -> label
  | Node(label,h::r) -> (List.fold_left
                           (fun a t ->  a^","^(to_string t))
                           (label^"("^(to_string h))
                           r
                        )^")"
  | Leaf label -> String.make 1 label                           
                                                                           
let rec print_trees trees indent =
  match trees with
  | [] -> ()
  | [t] ->
    print_tree t indent true
  | t::q ->
    print_tree t indent false;
    print_trees q indent

and print_tree tree indent last =
  match tree with
  | Leaf c ->
    Printf.printf "%s|-- Leaf: %c\n" indent c
  | Node (label, children) ->
    Printf.printf "%s|-- Node: %s\n" indent label;
    print_trees children (indent ^ (if last then "    " else "|   "))

let pretty_print_tree tree =
  print_trees [tree] ""
