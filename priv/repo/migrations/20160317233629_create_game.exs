defmodule PhoenixTimeline.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :code, :string, null: false
      add :status, :string
      add :initial_card_count, :integer
      add :card_order, {:array, :integer}
      add :player_order, {:array, :integer}
      add :timeline, {:array, :integer}
      add :turn_count, :integer
      timestamps
    end

    create unique_index(:games, [:code])
  end
end
