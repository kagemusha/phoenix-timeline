defmodule PhoenixTimeline.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :code, :string, null: false

      timestamps
    end

    create unique_index(:games, [:code])
  end
end
