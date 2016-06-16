defmodule PhoenixTimeline.Game do
  use PhoenixTimeline.Web, :model
  alias PhoenixTimeline.Repo
  alias PhoenixTimeline.Game
  alias PhoenixTimeline.Player
  alias PhoenixTimeline.Card
  alias PhoenixTimeline.Cardset

  schema "games" do
    has_many :players, Player
    belongs_to :cardset, Cardset
    field :name, :string
    field :code, :string
    field :status, :string, default: "waiting-to-start"
    field :initial_card_count, :integer
    field :card_order, {:array, :integer}
    field :turn_count, :integer, default: 0
    field :player_order, {:array, :integer}
    field :last_placement, :integer
    field :last_result, :boolean
    field :timeline, {:array, :integer}
    field :winner_id, :integer

    timestamps
  end

  def start(game_id) do
    game = game_with_players(game_id)
    #limit card set for game at some point
    game = Repo.preload game, cardset: :cards
    shuffled_card_ids = get_shuffled_ids game.cardset.cards
    shuffled_player_ids = get_shuffled_ids game.players

    game_updates = %{card_order: shuffled_card_ids,
                      player_order: shuffled_player_ids,
                      timeline: [ get_card_at(shuffled_card_ids, 0).id ],
                      turn_count: 1,
                      status: "started" }

    #some error handling later on
    {:ok, game} = cast(game, game_updates, ~w(card_order player_order turn_count status timeline), [])
                  |> Repo.update
    game
  end

  def card_placed(game_id, position) do

    game = game_with_players(game_id)
    {correct, card_id} = placement_correct(game, position)

    game_updates = %{ turn_count: game.turn_count + 1,
                      last_placement: position,
                      last_result: correct }
    if correct do
      new_timeline = List.insert_at game.timeline, position+1, card_id
      game_updates = Map.put game_updates, :timeline, new_timeline

      last_player = current_player(game)
      player_cards_remaining = last_player.cards_remaining - 1
      if player_cards_remaining == 0 do
        game_updates = Map.merge(game_updates, %{ status: "complete", winner_id: last_player.id})
      end
      player_updates = %{cards_remaining: player_cards_remaining}
      {:ok, last_player} = cast(last_player, player_updates, ~w(cards_remaining), [])
                              |> Repo.update
    end
    {:ok, game} = cast(game, game_updates, ~w(card_order player_order turn_count status timeline last_placement last_result ), ~w(winner_id) )
                  |> Repo.update
    get_state game.id
  end

  def get_state(game_id) do
    game = game_with_players game_id
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

    game_state = %{
      id: game.id,
      turn_count: game.turn_count,
      status: game.status,
      timeline: game.timeline,
      players: players
    }

    game_response = case game.turn_count do
      0 ->
        game_state
      _ ->

        last_player = player_at_turn game, game.turn_count - 1
        next_player = player_at_turn game, game.turn_count
        current_card = get_card_at(game.card_order, game.turn_count)

        #get cards
        timeline_cards = Repo.all(from c in Card, where: c.id in ^game.timeline)
        cards_json = Enum.map timeline_cards, &(%{id: &1.id, event: &1.event, year: &1.year})

        current_card_json = %{id: current_card.id, event: current_card.event}
        cards_json = cards_json ++ [ current_card_json ]

        last_card = get_card_at(game.card_order, game.turn_count - 1)
        if !game.last_result do
          #card won't be on timeline so must include
          cards_json = cards_json ++ [ %{id: last_card.id, event: last_card.event, year: last_card.year} ]
        end

        additional_game_state = %{
          cards: cards_json,
          last_card_id: last_card.id,
          last_player_id: last_player.id,
          last_placement: game.last_placement,
          last_result: game.last_result,
          current_card_id: current_card.id,
          current_player_id: next_player.id,
          winner_id: game.winner_id
        }
        Map.merge(game_state, additional_game_state)
    end
    %{game: game_response}
  end

  def first_turn(game) do
    current_card = get_card_at(game.card_order, game.turn_count)
    [ first_card_id ] = game.timeline
    first_card = Repo.get Card, first_card_id
    next_player = current_player(game)
    %{game: %{id: game.id,
              turn_count: game.turn_count,
              status: game.status,
              timeline: game.timeline,
              cards: [
                %{id: first_card.id, event: first_card.event, year: first_card.year},
                %{id: current_card.id, event: current_card.event}
              ],
              current_card_id: current_card.id,
              current_player_id: next_player.id,
      },
    }
  end


  def current_player(game) do
    player_at_turn game, game.turn_count
  end

  def placement_correct(game, position) do
    current_card = get_card_at(game.card_order, game.turn_count)
    card_year = current_card.year
    timeline = game.timeline
    end_position = Enum.count(timeline) - 1
    correct = case position do
      -1 ->
        card_year <= timelineYear(timeline, 0)
      ^end_position ->
        IO.puts "endPos: #{end_position}, year: #{card_year}"
        card_year >= timelineYear(timeline, end_position)
      _ ->
        IO.puts "----"
        correct = card_year >= timelineYear(timeline, position) &&
                  card_year <= timelineYear(timeline, position + 1)
    end
    {correct, current_card.id}
  end

  defp player_at_turn(game, turn) do
    index = rem(turn, Enum.count(game.players))
    player_id = Enum.at(game.player_order, index)
    Enum.find(game.players, fn(player)-> player.id == player_id end)
  end

  defp get_card_at(card_order, index) do
    card_id = Enum.at(card_order, index)
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

  defp timelineYear(timeline, position) do
    card_id = Enum.at(timeline, position)
    Repo.get(Card, card_id).year
  end
end
