defmodule PhoenixTimeline.Card do
  use PhoenixTimeline.Web, :model

  schema "cards" do
    field :event, :string
    field :year, :integer

    timestamps
  end

  @required_fields ~w(event year)
  @optional_fields ~w()

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
