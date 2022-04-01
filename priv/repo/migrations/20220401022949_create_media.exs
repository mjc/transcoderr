defmodule Transcoderr.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :name, :string
      add :extension, :string
      add :path, :string
      add :video_codec, :string
      add :library, references(:library, on_delete: :nothing)

      timestamps()
    end

    create index(:media, [:library])
  end
end
