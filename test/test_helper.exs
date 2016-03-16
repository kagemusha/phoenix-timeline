ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhoenixTimeline.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhoenixTimeline.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhoenixTimeline.Repo)

