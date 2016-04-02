defmodule PhoenixTimeline.Repo.Migrations.AddPlayerRelationsToGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :creator_id, references(:games, on_delete: :nothing)
      add :winner_id, references(:games, on_delete: :nothing)
    end
  end
end
