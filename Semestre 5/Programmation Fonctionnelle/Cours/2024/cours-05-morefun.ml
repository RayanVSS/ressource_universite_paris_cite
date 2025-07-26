(* Curiosité : un codage des entiers via juste des fonctions
   (Source : entiers de Church dans le lambda-calcul) *)

type 'a church = ('a -> 'a) -> 'a -> 'a

let zero : 'a church =  fun f x -> x
let one : 'a church =   fun f x -> f x
let two =   fun f x -> f (f x)
let three = fun f x -> f (f (f x))

let succ (n : 'a church) : 'a church = fun f x -> f (n f x)

let two' = succ (succ zero)
let three' = succ two'

let add (n : 'a church)(m : 'a church) : 'a church =
 fun f x -> m f (n f x)

let five = add three two

let to_int (n:'a church) : int = n (fun x -> x + 1) 0

let _ = to_int three
let _ = to_int three'
let _ = to_int five

let rec from_int n = if n = 0 then zero else succ (from_int (n-1))

let _ = to_int (add (from_int 5) (from_int 7))



(* Autre usage des fonctions : simuler des structures infinies *)

type 'a stream = Stream of 'a * (unit -> 'a stream)

let rec from n = Stream (n, fun () -> from (n+1))

let naturals = from 0  (* tous les entiers naturels !! *)

let head = function Stream (a, _) -> a

let tail = function Stream (_, next) -> next ()

let two = head (tail (tail naturals))

let rec prefix n s =
  match n,s with
  | 0, _ -> []
  | _, Stream (a, next) -> a :: prefix (n-1) (next ())

let _ = prefix 100 naturals

let rec nth n s =
  if n = 0 then head s else nth (n-1) (tail s)

let million = nth 1000000 naturals

let rec everyother s =
  Stream (head s, fun () -> everyother (tail (tail s)))

let even_naturals = everyother naturals

let _ = prefix 100 even_naturals

let twomillion = nth 1000000 even_naturals

let rec filter f =
  function Stream (a,next) ->
    if f a then filter f (next ())
    else Stream (a, fun () -> filter f (next ()))

let rec crible =
  function Stream (a,next) ->
    Stream (a, fun () -> crible (filter (fun x -> x mod a <> 0) (next ())))

let allprimes = primes (from 2)
let _ = prefix 100 allprimes
