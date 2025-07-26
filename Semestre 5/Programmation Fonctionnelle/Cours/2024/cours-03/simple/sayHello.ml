let _init =
  Random.self_init ()

let hellos = [
    "Hello";
    "Bonjour";
    "Hallo";
    "Buenas dias";
]

let pick_one () =
  List.nth hellos (Random.int (List.length hellos))

let say_it () =
  Printf.printf "%s!\n" (pick_one ())
