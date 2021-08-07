// @val @scope("JSON")
// external parseIntoState: string => state = "parse"

// module type block = {

// }


// module Item = {
//   type t = item;
//   let eq = (x1, x2) => x1 == x2;
//   let cmp = compare;
// };


// module Container = Dnd.MakeSingletonContainer();
// module Items = Dnd.Make(Item, Container);

// type state = array<item>

// type action =
//   | ReorderItems(Dnd.result<Item.t, Container.t>)

// let reducer = (state, action) => switch (action) {
// | ReorderItems(Some(SameContainer(item, placement))) =>
//   // Item has landed in the new position of the same container,
//   // so it should be reinserted from the old position
//   // in the array into the new one.
//   // `ArrayExt.reinsert` is a helper which does just this.
//   state->ArrayExt.reinsert(
//     ~value=item,
//     ~place=
//       switch (placement) {
//       | Before(id) => #Before(id)
//       | Last => #Last
//       },
//   )

// // not possible since we have only one container
// | ReorderItems(Some(NewContainer(_)))
// | ReorderItems(None) => state
// }

// let initialState = [1,2,3]

// module App = {
//   type state = {
//     count: int
//   }

//   @react.component
//   let make = () => {
//     let text = Common.greet(#Client)

//     // let state = try {
//     //   Some(parseIntoState("asdf"))
//     // } catch {
//     //   | Js.Exn.Error(obj) =>
//     //     switch Js.Exn.message(obj) {
//     //     | Some(m) => Js.log("Caught a JS exception! Message: " ++ m)
//     //     | None => ()
//     //     };
//     //     None
//     // }

//     // let (state, setState) = React.useState(_ => { count: 0 });


//     let (state, dispatch) = reducer->React.useReducer(initialState);

//     <Items.DndManager onReorder={result => ReorderItems(result)->dispatch}>
//       <Items.DroppableContainer id={Container.id()} axis=Y>
//         {state
//         ->Belt.Array.mapWithIndex((index, item) => {
//             <Items.DraggableItem
//               id={item}
//               key={item->Belt.Int.toString}
//               containerId={Container.id()}
//               index>
//               {#Children(item->Belt.Int.toString->React.string)}
//             </Items.DraggableItem>;
//           })
//         ->React.array}
//       </Items.DroppableContainer>
//     </Items.DndManager>;
//   }
// }

switch(ReactDOM.querySelector("#root")){
| Some(root) => ReactDOM.render(<Main />, root)
| None => Js.Console.error("No #root elemeent found")
}


