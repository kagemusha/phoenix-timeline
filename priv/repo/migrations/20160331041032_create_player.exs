defmodule PhoenixTimeline.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :total_cards, :integer
      add :cards_remaining, :integer
      add :turn_position, :integer
      add :game_id, references(:games, on_delete: :nothing)

      timestamps
    end
    create index(:players, [:game_id])

  end
end
