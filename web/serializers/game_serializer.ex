defmodule PhoenixTimeline.GameSerializer do
  use JaSerializer

  location "/games/:id"
  attributes [:code]
end