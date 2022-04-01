defmodule Transcoderr.Libraries.Medium do
  use Ecto.Schema
  import Ecto.Changeset

  schema "media" do
    field :extension, :string
    field :name, :string
    field :path, :string
    field :video_codec, :string
    field :library, :id

    timestamps()
  end

  @doc false
  def changeset(medium, attrs) do
    medium
    |> cast(attrs, [:name, :extension, :path, :video_codec])
    |> validate_required([:name, :extension, :path, :video_codec])
  end
end
