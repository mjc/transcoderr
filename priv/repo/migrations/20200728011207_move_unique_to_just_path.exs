defmodule Transcoderr.Repo.Migrations.MoveUniqueToJustPath do
  use Ecto.Migration

  def change do
    drop unique_index(:media, [:path, :library_id])
    create unique_index(:media, [:path])
    create unique_index(:libraries, [:path])
  end
end
