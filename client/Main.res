open Belt

open Common


// let renderExpr = (expr) => {
//   <div>
//     <p>
//       React.string(
//         switch(expr.type_) {
//           | And => "and"
//           | Or => "or"
//         }
//       )
//     </p>
//   </div>
// }


let renderExprField = (exprFieldId) => {
  <Exprs.DroppableContainer
    id=exprFieldId
    key={exprFieldId->ExprFieldId.toString}
    axis=Y
  >
  {<div></div>}
  </Exprs.DroppableContainer>
}

let renderStatField = (statFieldId) => {
  <Stats.DroppableContainer
    id=statFieldId
    key={statFieldId->StatFieldId.toString}
    axis=Y
  >
    {<div></div>}
  </Stats.DroppableContainer>
}

let renderBlock = (i, block) => {

  switch(block) {
    | Root(root) =>
      <Roots.DraggableItem
        id=root.id
        key={root.id->RootId.toString}
        containerId={Roots.Container.id()}
        index=i
      >
        #ChildrenWithDragHandle(
          (~style, ~onMouseDown, ~onTouchStart) =>
          <>
            {
              root.exprFieldIds
              ->Array.map(renderExprField)
              ->React.array
            }
            {root.statFieldId
            ->Option.mapWithDefault(<p></p>, renderStatField)
            }
          </>
        )
      </Roots.DraggableItem>

    | Expr(expr) =>
      <Exprs.DraggableItem
        id=expr.id
        key={expr.id->ExprId.toString}
        containerId={expr.parentId}
        index=i
      >
        #ChildrenWithDragHandle(
          (~style, ~onMouseDown, ~onTouchStart) =>
          {
            expr.exprFieldIds
            ->Array.map(renderExprField)
            ->React.array
          }
        )
      </Exprs.DraggableItem>

    | Stat(stat) =>
      <Stats.DraggableItem
        id=stat.id
        key={stat.id->StatId.toString}
        containerId={stat.parentId}
        index=i
      >
        #ChildrenWithDragHandle(
          (~style, ~onMouseDown, ~onTouchStart) =>
          {
            stat.exprFieldIds
            ->Array.map(renderExprField)
            ->React.array
          }
        )
      </Stats.DraggableItem>
  }
}


@react.component
let make = () => {
  let (state, dispatch) = State.make()

  <Roots.DndManager onReorder={result => State.ReorderRoots(result)->dispatch}>
    <Stats.DndManager onReorder={result => State.ReorderStats(result)->dispatch}>
      <Exprs.DndManager onReorder={result => State.ReorderExprs(result)->dispatch}>
        <Roots.DroppableContainer
          id={Roots.Container.id()} axis=Y
        >
          {
            state.rootIndices
            ->Array.mapWithIndex((i, rootIndex) => {
              renderBlock(i, Root(state.roots->Map.getExn(rootIndex)))
            })
            ->React.array
          }
        </Roots.DroppableContainer>

        // <Roots.DroppableContainer
        //   id={Roots.Container.id()} axis=Y
        // >
        // </Roots.DroppableContainer>

      </Exprs.DndManager>
    </Stats.DndManager>
  </Roots.DndManager>
}
