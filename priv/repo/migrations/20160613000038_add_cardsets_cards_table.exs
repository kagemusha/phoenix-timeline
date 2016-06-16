defmodule PhoenixTimeline.Repo.Migrations.AddCardsetsCardsTable do
  use Ecto.Migration

  def change do
    create table(:cardsets_cards) do
      add :cardset_id, :integer
      add :card_id, :integer
    end
  end
end
