open Belt

let id = ref(0)

module type Identity = {
  type t
  let new: unit => t
  let eq: (t, t) => bool
  let cmp: (t, t) => int
  let toString: t => string

  module Comparable : Belt.Id.Comparable

  module Map : {
    type t<'t> = Belt.Map.t<t, 't, Comparable.identity>
    let make: () => t<'t>
    let fromArray: array<(Comparable.t, 't)> => t<'t>
  }

  module DndEntry : Dnd__Config.DndEntry with type t = t
}

module Make = (): Identity => {
  module Id: {
    type t
  } = {
    type t = int
  }

  include Id

  external make: int => t = "%identity"
  external toInt: t => int = "%identity"

  let new = () => {
    id := id.contents + 1
    make(id.contents)
  }

  let toString = x => x->toInt->Int.toString

  let eq = (x1, x2) => x1->toInt == x2->toInt
  let cmp = (x1, x2) => Pervasives.compare(x1->toInt, x2->toInt)

  module Comparable = Belt.Id.MakeComparable({
    type t = Id.t
    let cmp = cmp
  })

  module Map = {
    type t<'t> = Map.t<t, 't, Comparable.identity>;

    let make = () => Map.make(~id=module(Comparable))
    let fromArray = array => Map.fromArray(array, ~id=module(Comparable))
  }

  module DndEntry = {
    type t = t

    let eq = eq
    let cmp = cmp
  }
}
