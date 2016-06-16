defmodule PhoenixTimeline.Api.CardsetView do
  use PhoenixTimeline.Web, :view

  def render("index.json", %{cardsets: cardsets}) do
    %{cardsets: Enum.map(cardsets, &( %{
          id: &1.id,
          name: &1.name,
          display_name: &1.display_name
        }
    ))}
  end

end
