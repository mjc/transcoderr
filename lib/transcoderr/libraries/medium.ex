defmodule Transcoderr.Libraries.Medium do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "media" do
    field :extension, :string
    field :name, :string
    field :path, :string
    field :video_codec, :string
    field :library_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(medium, attrs) do
    medium
    |> cast(attrs, [:name, :path, :extension, :video_codec])
    |> validate_required([:name, :path, :extension, :video_codec])
  end
end
