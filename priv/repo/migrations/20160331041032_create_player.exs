defmodule PhoenixTimeline.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :cards_remaining, :integer
      add :turn_position, :integer
      add :is_creator, :boolean
      add :is_winner, :boolean
      add :token, :string
      add :game_id, references(:games, on_delete: :delete_all)

      timestamps
    end
    create index(:players, [:game_id])

  end
end
