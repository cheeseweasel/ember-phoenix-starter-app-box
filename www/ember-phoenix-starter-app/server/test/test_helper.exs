ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Starterapp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Starterapp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Starterapp.Repo)

