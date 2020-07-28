defmodule Transcoderr.Repo.Migrations.AddUniqueIndexToMedia do
  use Ecto.Migration

  def change do
    create unique_index(:media, [:path, :library_id])
  end
end
