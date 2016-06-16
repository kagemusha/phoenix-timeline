defmodule PhoenixTimeline.Card do
  use PhoenixTimeline.Web, :model
  alias PhoenixTimeline.Cardset

  schema "cards" do
    many_to_many :cardsets, Cardset, join_through: "cardsets_cards"
    field :event, :string
    field :year, :integer
    field :month, :integer

    timestamps
  end

  @required_fields ~w(event year)
  @optional_fields ~w()


  def compare(card1, card2) do
    time1 = time_val card1
    time2 = time_val card2
    cond do
      time1 > time2 -> 1
      time1 < time1 -> -1
      time1 == time2 -> 0
    end
  end

  def time_val(card) do
    month = card.month || 0
    card.year + 0.01 * month
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end


end
