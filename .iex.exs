import Ecto.Queryable
alias PhoenixTimeline.Repo
alias PhoenixTimeline.Game
alias PhoenixTimeline.Card
alias PhoenixTimeline.Player

defmodule R do
  def reload! do
    Mix.Task.reenable "compile.elixir"
    Application.stop(Mix.Project.config[:app])
    Mix.Task.run "compile.elixir"
    Application.start(Mix.Project.config[:app], :permanent)
  end
end