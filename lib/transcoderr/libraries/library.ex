defmodule Transcoderr.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "libraries" do
    field :name, :string
    field :path, :string
    has_many :media, Transcoderr.Libraries.Medium

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :path])
    |> validate_required([:name, :path])
    |> validate_path(:path)
    |> unique_constraint([:path])
  end

  def validate_path(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, path ->
      case File.dir?(path) do
        true -> []
        false -> [{field, options[:message] || "Invalid Path"}]
      end
    end)
  end
end
