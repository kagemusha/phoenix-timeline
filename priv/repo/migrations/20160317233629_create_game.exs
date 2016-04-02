defmodule PhoenixTimeline.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :code, :string, null: false
      add :status, :string, default: "waiting-to-start"
      timestamps
    end

    create unique_index(:games, [:code])
  end
end
