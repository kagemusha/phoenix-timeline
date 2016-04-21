defmodule PhoenixTimeline.Game do
  use PhoenixTimeline.Web, :model
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Card

  schema "games" do
    field :name, :string
    field :code, :string
    field :status, :string
    field :card_order, {:array, :integer}
    field :turn_count, :integer
    field :player_order, {:array, :integer}
    has_many :players, PhoenixTimeline.Player
    timestamps
  end

  @required_fields ~w(code)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def start(game) do
    shuffled_card_ids = Repo.all(Card)
                |> Enum.map(&(&1.id))
                |> Enum.shuffle

    game = Repo.preload game, :players
    shuffled_player_ids = game.players
                |> Enum.map(&(&1.id))
                |> Enum.shuffle

    game_updates = %{card_order: shuffled_card_ids,
                      player_order: shuffled_player_ids,
                      turn_count: 1,
                      status: "in-progress" }

    #some error handling later on
    {:ok, game} = cast(game, game_updates, ~w(card_order player_order turn_count status))
                  |> Repo.update
    game
  end

  def current_turn(game) do
    game = Repo.preload game, :players
    player_index = rem(game.turn_count, Enum.count(game.players))
    current_player = Enum.at(game.players, player_index)
    card_id = Enum.at(game.card_order, game.turn_count)
    current_card = Repo.get Card, card_id
    require IEx; IEx.pry
    %{count: game.turn_count,
      current_player: current_player.id,
      current_card: %{card: %{event: current_card.event}}
    }

  end


end
