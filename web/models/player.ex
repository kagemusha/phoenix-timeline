defmodule PhoenixTimeline.Player do
  use PhoenixTimeline.Web, :model
  alias PhoenixTimeline.Repo

  schema "players" do
    field :name, :string
    field :token, :string
    field :cards_remaining, :integer
    field :turn_position, :integer
    field :is_creator, :boolean
    field :is_winner, :boolean
    has_one :victory, PhoenixTimeline.Game, foreign_key: :winner_id
    has_one :created_game, PhoenixTimeline.Game, foreign_key: :creator_id

    belongs_to :game, PhoenixTimeline.Game

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(cards_remaining turn_position is_creator is_winner token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def create(conn, game, name, is_creator \\ false) do
    token = Phoenix.Token.sign conn, "something salty", "#{name}-#{game.code}"
    changeset =
      build_assoc(game, :players)
      |> changeset(%{name: name, token: token, is_creator: is_creator, cards_remaining: game.initial_card_count })
    Repo.insert(changeset)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
