open Belt
open Common

type t = {
  exprs: ExprId.Map.t<expr>,
  exprFields: ExprFieldId.Map.t<exprField>,
  stats: StatId.Map.t<stat>,
  statFields: StatFieldId.Map.t<statField>,
  roots: RootId.Map.t<root>,
  rootIndices: array<RootId.t>,
}

type action =
  | ReorderRoots(Dnd.result<Roots.Item.t, Roots.Container.t>)
  | ReorderExprs(Dnd.result<Exprs.Item.t, Exprs.Container.t>)
  | ReorderStats(Dnd.result<Stats.Item.t, Stats.Container.t>)

let reducer = (state, action) =>
  switch action {
  | ReorderExprs(Some(NewContainer(exprId, containerId, _placement))) =>
    let expr = state.exprs->Map.getExn(exprId)
    {
      ...state,
      exprs: state.exprs->Map.update(exprId, x =>
        x->Option.map(expr => {...expr, parentId: containerId})
      ),
      exprFields: state.exprFields
      ->Map.update(expr.parentId, x => x->Option.map(field => {...field, childId: None}))
      ->Map.update(containerId, x => x->Option.map(field => {...field, childId: Some(exprId)})),
    }

  | ReorderRoots(Some(SameContainer(rootId, placement))) => {
      ...state,
      rootIndices: state.rootIndices->ArrayExt.reinsert(
        ~value=rootId,
        ~place=switch placement {
        | Before(id) => #Before(id)
        | Last => #Last
        },
      ),
    }

  | ReorderStats(Some(NewContainer(statId, containerId, placement))) =>
    let stat = state.stats->Map.getExn(statId)
    {
      ...state,
      stats: state.stats->Map.update(statId, x =>
        x->Option.map(stat => {...stat, parentId: containerId})
      ),
      statFields: state.statFields
      ->Map.update(stat.parentId, x =>
        x->Option.map(field => {
          ...field,
          childIds: field.childIds->Array.keep(id => !StatId.eq(id, statId))
        })
      )
      ->Map.update(containerId, x =>
        x->Option.map(field => {
          ...field,
          childIds: field.childIds->ArrayExt.insert(
            ~value=statId,
            ~place=switch placement {
            | Before(id) => #Before(id)
            | Last => #Last
            },
          ),
        })
      ),
    }

  | ReorderStats(Some(SameContainer(statId, placement))) =>
    let stat = state.stats->Map.getExn(statId)
    {
      ...state,
      statFields: state.statFields
      ->Map.update(stat.parentId, x =>
        x->Option.map(field => {
          ...field,
          childIds: field.childIds->ArrayExt.reinsert(
            ~value=statId,
            ~place=switch placement {
            | Before(id) => #Before(id)
            | Last => #Last
            },
          ),
        })
      ),
    }

  | ReorderRoots(None)
  | ReorderRoots(Some(NewContainer(_)))
  | ReorderExprs(None)
  | ReorderExprs(Some(SameContainer(_)))
  | ReorderStats(None) => state
  }

// let normalize = (roots) => {

//   let exprs = roots
//     ->Array.mapWithIndex((i, exprType) => {
//       let id = ExprId.new()
//       (id, { id, exprFieldIds: [], type_: exprType })
//     })
//     ->ExprId.Map.fromArray()

//   let rootBlockIndices = Map.keysToArray(exprs)

//   { exprs, rootBlockIndices }
// }

let init = ()


let make = () => {
  let rootTypes = [Always, When]
  let exprTypes = [And, Or]
  let statTypes = [Call, Assign]


  let initial = {
    exprs: ExprId.Map.make(),
    stats: StatId.Map.make(),
    statFields: StatFieldId.Map.make(),
    roots: RootId.Map.make(),
    rootIndices: [],
    exprFields: ExprFieldId.Map.make()
  }

  reducer->React.useReducer(initial)
}
