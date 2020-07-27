defmodule Transcoderr.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :path, :string

      timestamps()
    end

  end
end
