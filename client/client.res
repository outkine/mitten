module App = {
  type state = {
    count: int
  }

  @react.component
  let make = () => {
    let text = Common.greet(#Client)

    let (state, setState) = React.useState(_ => { count: 0 });

    <div>
      <p> { React.string(text) </p>
      <p> { React.int(state.count) } </p>
      <button onClick={_ => setState(state => { count: state.count + 1 })}>
        { React.string("Increase") }
      </button>
    </div>
  }
}

switch(ReactDOM.querySelector("#root")){
| Some(root) => ReactDOM.render(<App />, root)
| None => Js.Console.error("No #root elemeent found")
}
