defmodule PhoenixTimeline.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :event, :string
      add :year, :integer

      timestamps
    end

  end
end
