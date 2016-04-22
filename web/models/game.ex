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

  def get_card_at(game, count) do
    card_id = Enum.at(game.card_order, count)
    Repo.get Card, card_id
  end

  def current_turn(game, correct_answer) do
    game = Repo.preload game, :players
    player_index = rem(game.turn_count, Enum.count(game.players))
    current_player = Enum.at(game.players, player_index)
    current_card = get_card_at(game, game.turn_count)
    last_card = if correct_answer, do: get_card_at(game, game.turn_count - 1), else: nil
    %{count: game.turn_count,
      current_player: current_player.id,
      #last_card will be previous card if correct or the first card for board
      last_card: %{card: %{event: last_card.event, year: last_card.year}},
      current_card: %{card: %{event: current_card.event}}
    }

  end


end
