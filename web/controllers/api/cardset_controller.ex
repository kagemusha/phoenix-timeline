defmodule PhoenixTimeline.Api.CardsetController do
  use PhoenixTimeline.Web, :controller

  alias PhoenixTimeline.Cardset

  def index(conn, _params) do
    cardsets = Repo.all(Cardset)
    render(conn, "index.json", %{cardsets: cardsets})
  end

end
