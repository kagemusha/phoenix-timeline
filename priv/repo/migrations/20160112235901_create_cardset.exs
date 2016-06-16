defmodule PhoenixTimeline.Repo.Migrations.CreateCardset do
  use Ecto.Migration

  def change do
    create table(:cardsets) do
      add :name, :string
      add :display_name, :string
      add :description, :string

      timestamps
    end

  end
end
