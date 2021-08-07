type _ expr =
| Unit : unit -> unit expr

| Bool : bool -> bool expr

| Not : bool expr -> bool expr
| And : bool expr * bool expr -> bool expr
| Or : bool expr * bool expr -> bool expr

| Int : int -> int expr

| Add : int expr * int expr -> int expr
| Sub : int expr * int expr -> int expr
| Mul : int expr * int expr -> int expr
| Div : int expr * int expr -> int expr
| Mod : int expr * int expr -> int expr

| Lt : int expr * int expr -> bool expr
| Lte : int expr * int expr -> bool expr
| Gt : int expr * int expr -> bool expr
| Gte : int expr * int expr -> bool expr
| Eq : int expr * int expr -> bool expr
| Neq : int expr * int expr -> bool expr

| Tuple : 'a expr * 'b expr -> ('a * 'b) expr
| Tuple3 : 'a expr * 'b expr * 'c expr -> ('a * 'b * 'c) expr
| Tuple4 : 'a expr * 'b expr * 'c expr * 'd expr -> ('a * 'b * 'c * 'd) expr

| Val : (unit -> 'a) -> 'a expr
| Map : ('a -> 'b) * 'a expr -> 'b expr


let rec eval : type a . a expr -> a = function
| Unit () -> ()

| Bool a -> a

| Not a -> not @@ eval a
| And (a, b) -> eval a && eval b
| Or (a, b) -> eval a || eval b

| Int a -> a

| Add (a, b) -> eval a + eval b
| Sub (a, b) -> eval a - eval b
| Mul (a, b) -> eval a * eval b
| Div (a, b) -> eval a / eval b
| Mod (a, b) -> eval a mod eval b

| Lt (a, b) -> eval a < eval b
| Lte (a, b) -> eval a <= eval b
| Gt (a, b) -> eval a > eval b
| Gte (a, b) -> eval a >= eval b
| Eq (a, b) -> eval a = eval b
| Neq (a, b) -> eval a <> eval b

| Tuple (a, b) -> (eval a, eval b)
| Tuple3 (a, b, c) -> (eval a, eval b, eval c)
| Tuple4 (a, b, c, d) -> (eval a, eval b, eval c, eval d)

| Val f -> f ()
| Map (f, a) -> f @@ eval a


type 'a statement =
| Assign of string * 'a expr
| Call of ('a -> unit) * 'a expr

type 'a top_level =
| Always of 'a statement
| When of bool expr * 'a statement

type 'a state = 'a top_level list

(* let rec simplify = function
| Base _ | Const _ as x -> x
| And l -> and_ (List.map ~f:simplify l)
| Or l  -> or_  (List.map ~f:simplify l)
| Not e -> not_ (simplify e)



type 'a expr =
| Base  of 'a
| Const of bool
| And   of 'a expr list
| Or    of 'a expr list
| Not   of 'a expr *)
