defmodule PhoenixTimeline.PageController do
  use PhoenixTimeline.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
