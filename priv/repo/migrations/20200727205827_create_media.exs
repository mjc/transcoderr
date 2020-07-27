defmodule Transcoderr.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :path, :string
      add :extension, :string
      add :video_codec, :string
      add :library_id, references(:libraries, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:media, [:library_id])
  end
end
