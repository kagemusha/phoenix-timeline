defmodule Mix.Tasks.PhoenixTimeline.CullOldGames do
  import Ecto.Query, only: [from: 1, from: 2]
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Game

  @shortdoc "Culls old games"

  def cull do
    %{amount: all_amount, unit: all_units} = Application.get_env(:phoenix_timeline, :cull_all_games_after)
    %{amount: complete_amount, unit: complete_units, } = Application.get_env(:phoenix_timeline, :cull_complete_games_after)
    culls = from g in Game,
            where: g.updated_at < ago(^all_amount, ^all_units) or (g.updated_at < ago(^complete_amount, ^complete_units) and g.status == "complete")
    Repo.delete_all culls
  end
end