defmodule PhoenixTimeline.Game do
  use PhoenixTimeline.Web, :model
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player
  alias PhoenixTimeline.Card

  schema "games" do
    field :name, :string
    field :code, :string
    field :status, :string
    field :initial_card_count, :integer
    field :card_order, {:array, :integer}
    field :turn_count, :integer
    field :player_order, {:array, :integer}
    field :timeline, {:array, :integer}
    has_many :players, Player
    timestamps
  end

  def start(game_id) do
    game = game_with_players(game_id)
    #limit card set for game at some point
    shuffled_card_ids = get_shuffled_ids Repo.all(Card)
    shuffled_player_ids = get_shuffled_ids game.players

    game_updates = %{card_order: shuffled_card_ids,
                      player_order: shuffled_player_ids,
                      timeline: [ get_card_at(shuffled_card_ids, 0).year ],
                      turn_count: 1,
                      status: "in-progress" }

    #some error handling later on
    {:ok, game} = cast(game, game_updates, ~w(card_order player_order turn_count status timeline), [])
                  |> Repo.update
    game
  end

  def card_placed(game_id, position) do
    game = game_with_players(game_id)
    [correct, card_year] = placement_correct(position, game)

    game_updates = %{turn_count: game.turn_count + 1}
    if correct do
      new_timeline = List.insert_at game.timeline, position+1, card_year
      game_updates = Map.put game_updates, :timeline, new_timeline
      current_player = current_player(game)

      player_updates = %{cards_remaining: (current_player.cards_remaining - 1) }
      {:ok, current_player} = cast(current_player, player_updates, ~w(cards_remaining), [])
                              |> Repo.update
    end

    {:ok, game} = cast(game, game_updates, ~w(card_order player_order turn_count status timeline), [])
                  |> Repo.update
    next_turn(game.id, position, correct)
  end

  def next_turn(game_id, position, correct_answer) do

    game = game_with_players game_id

    current_player = current_player(game)
    current_card = get_card_at(game.card_order, game.turn_count)

    last_card = get_card_at(game.card_order, game.turn_count - 1)
    last_card_json = %{card: %{id: last_card.id, event: last_card.event, year: last_card.year}}
    last_player = player_at_turn(game, game.turn_count - 1)
    winnerId = nil
    if correct_answer do
      if last_player.cards_remaining == 0 do
        winnerId = last_player.id
      end
    end
    %{turn_count: game.turn_count,
      position: position,
      correct: correct_answer,
      current_player: current_player.id,
      last_card: last_card_json,
      current_card: %{card: %{id: current_card.id, event: current_card.event}},
      winner_id: winnerId
    }
  end

  def current_player(game) do
    player_at_turn game, game.turn_count
  end

  defp player_at_turn(game, turn) do
    index = rem(turn, Enum.count(game.players))
    player_id = Enum.at(game.player_order, index)
    Enum.find(game.players, fn(player)-> player.id == player_id end)
  end

  defp get_card_at(card_order, count) do
    card_id = Enum.at(card_order, count)
    Repo.get Card, card_id
  end

  defp get_shuffled_ids(object_list) do
    object_list
      |> Enum.map(&(&1.id))
      |> Enum.shuffle
  end

  defp game_with_players(game_id) do
    Repo.get!(Game, game_id)
    |> Repo.preload(:players)
  end

  defp placement_correct(position, game) do
    current_card = get_card_at(game.card_order, game.turn_count)
    card_year = current_card.year
    timeline = game.timeline
    timeline_event_count = Enum.count timeline
    case position do
      -1 ->
        [ card_year <= List.first(timeline), card_year]
      ^timeline_event_count ->
        [card_year >= List.last(timeline), card_year]
      _ ->
        correct = (card_year >= Enum.at(timeline, position)) &&
                  (card_year <= Enum.at(timeline, position + 1))
        [correct, card_year]
    end
  end

end
