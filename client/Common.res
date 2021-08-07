module RootId = Identity.Make()

module ExprId = Identity.Make()

module StatId = Identity.Make()

module ExprFieldId = Identity.Make()

module StatFieldId = Identity.Make()

type exprField = {
  id: ExprFieldId.t,
  childId: option<ExprId.t>,
}

type statField = {
  id: StatFieldId.t,
  childIds: array<StatId.t>,
}

type rootType =
  | Always
  | When

type root = {
  id: RootId.t,
  exprFieldIds: array<ExprFieldId.t>,
  statFieldId: option<StatFieldId.t>,
  type_: rootType,
}

type exprType =
  | And
  | Or

type expr = {
  id: ExprId.t,
  exprFieldIds: array<ExprFieldId.t>,
  parentId: ExprFieldId.t,
  type_: exprType,
}

type statType =
  | Call
  | Assign

type stat = {
  id: StatId.t,
  exprFieldIds: array<ExprFieldId.t>,
  parentId: StatFieldId.t,
  type_: statType,
}


type block =
  | Root(root)
  | Expr(expr)
  | Stat(stat)



module Roots = {
  module Item = RootId.DndEntry

  module Container = Dnd.MakeSingletonContainer()

  include Dnd.Make(Item, Container)
}

module Exprs = {
  module Item = ExprId.DndEntry

  module Container = ExprFieldId.DndEntry

  include Dnd.Make(Item, Container)
}

module Stats = {
  module Item = StatId.DndEntry

  module Container = StatFieldId.DndEntry

  include Dnd.Make(Item, Container)
}
