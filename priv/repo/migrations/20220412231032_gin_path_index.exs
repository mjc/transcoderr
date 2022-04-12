defmodule Transcoderr.Repo.Migrations.GinPathIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:media, [:path])
    drop_if_exists index(:libraries, [:path])

    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")
    execute("CREATE EXTENSION IF NOT EXISTS btree_gin")
    create index(:libraries, [:path], using: :gin)
    create index(:media, [:path], using: :gin)

    execute("CREATE EXTENSION IF NOT EXISTS pg_stat_statements")
  end
end
