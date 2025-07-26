(* Un petit "hello world" en OCaml.
   La majeur partie du code est dans sayHello.ml, pour montrer l'usage
   de différents modules.

   A compiler via: ocamlopt -o hello sayHello.mli sayHello.ml hello.ml
   Puis: ./hello

   Ou mieux, en utilisant l'outil dune automatisant la compilation:
     dune build ./hello.exe
   Puis pour lancer: dune exec ./hello.exe
*)

let main =
  SayHello.say_it ()
