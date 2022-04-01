defmodule Transcoderr.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :name, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :path])
    |> validate_required([:name, :path])
    |> validate_path(:path)
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
