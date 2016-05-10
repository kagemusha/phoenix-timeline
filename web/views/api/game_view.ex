defmodule PhoenixTimeline.Api.GameView do
  use PhoenixTimeline.Web, :view

  def render("created_game.json", %{game: game}) do
    [player] = game.players
    %{game:
      %{
        id: game.id,
        code: game.code,
        players: [%{
                    id: player.id,
                    token: player.token,
                    name: player.name,
                    is_creator: true,
                    cards_remaining: player.cards_remaining,
        }]
      }
    }
  end

  def render("players.json", %{game: game}) do
    game = Repo.preload game, :players
    players = Enum.map(game.players, fn (player) ->
        %{
          id: player.id,
          name: player.name,
          is_creator: player.is_creator,
          cards_remaining: player.cards_remaining,
          game: game.id
        }
      end
    )
    %{players: players}
  end
end
