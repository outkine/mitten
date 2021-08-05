let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [

    Dream.get "/"
      (fun _ -> Dream.html Index.index);

    Dream.get "/static/**"
      (Dream.static "./static");

  ]
  @@ Dream.not_found
