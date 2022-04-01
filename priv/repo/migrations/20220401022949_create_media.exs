defmodule Transcoderr.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :name, :string
      add :extension, :string
      add :path, :string
      add :video_codec, :string
      add :library_id, references(:libraries, on_delete: :nothing)

      timestamps()
    end

    create index(:media, [:library_id])
  end
end
