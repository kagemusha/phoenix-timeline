import Ecto.Queryable
import Ecto.Query, only: [from: 1, from: 2]
alias PhoenixTimeline.Repo
alias PhoenixTimeline.Game
alias PhoenixTimeline.Card
alias PhoenixTimeline.Cardset
alias PhoenixTimeline.Player

defmodule R do
  def reload! do
    Mix.Task.reenable "compile.elixir"
    Application.stop(Mix.Project.config[:app])
    Mix.Task.run "compile.elixir"
    Application.start(Mix.Project.config[:app], :permanent)
  end
end