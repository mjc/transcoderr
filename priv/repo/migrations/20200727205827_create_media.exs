defmodule Transcoderr.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :path, :string, size: 8_192
      add :extension, :string
      add :video_codec, :string
      add :library_id, references(:libraries, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:media, [:library_id])
  end
end
