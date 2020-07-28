defmodule Transcoderr.Libraries do
  @moduledoc """
  The Libraries context.
  """

  import Ecto.Query, warn: false
  alias Transcoderr.Repo

  alias Transcoderr.Libraries.Library

  @doc """
  Returns the list of libraries.

  ## Examples

      iex> list_libraries()
      [%Library{}, ...]

  """
  def list_libraries do
    Repo.all(Library)
  end

  @doc """
  Gets a single library.

  Raises `Ecto.NoResultsError` if the Library does not exist.

  ## Examples

      iex> get_library!(123)
      %Library{}

      iex> get_library!(456)
      ** (Ecto.NoResultsError)

  """
  def get_library!(id), do: Repo.get!(Library, id)

  @spec get_library_by_path(String.t()) :: Library.t()
  def get_library_by_path(path) do
    Enum.find(
      Repo.all(Library),
      fn library -> String.starts_with?(path, library.path) end
    )
  end

  @doc """
  Creates a library.

  ## Examples

      iex> create_library(%{field: value})
      {:ok, %Library{}}

      iex> create_library(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_library(attrs \\ %{}) do
    %Library{}
    |> Library.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a library.

  ## Examples

      iex> update_library(library, %{field: new_value})
      {:ok, %Library{}}

      iex> update_library(library, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_library(%Library{} = library, attrs) do
    library
    |> Library.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a library.

  ## Examples

      iex> delete_library(library)
      {:ok, %Library{}}

      iex> delete_library(library)
      {:error, %Ecto.Changeset{}}

  """
  def delete_library(%Library{} = library) do
    Repo.delete(library)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking library changes.

  ## Examples

      iex> change_library(library)
      %Ecto.Changeset{data: %Library{}}

  """
  def change_library(%Library{} = library, attrs \\ %{}) do
    Library.changeset(library, attrs)
  end

  alias Transcoderr.Libraries.Medium

  @doc """
  Returns the list of media.

  ## Examples

      iex> list_media()
      [%Medium{}, ...]

  """
  def list_media do
    Repo.all(Medium)
  end

  @doc """
  Gets a single medium.

  Raises `Ecto.NoResultsError` if the Medium does not exist.

  ## Examples

      iex> get_medium!(123)
      %Medium{}

      iex> get_medium!(456)
      ** (Ecto.NoResultsError)

  """
  def get_medium!(id), do: Repo.get!(Medium, id)

  def get_medium_by_path(path), do: Repo.get_by(Medium, path: path)

  @doc """
  Creates a medium.

  ## Examples

      iex> create_medium(%{field: value})
      {:ok, %Medium{}}

      iex> create_medium(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medium(attrs \\ %{}) do
    %Medium{}
    |> Medium.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a medium.

  ## Examples

      iex> update_medium(medium, %{field: new_value})
      {:ok, %Medium{}}

      iex> update_medium(medium, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_medium(%Medium{} = medium, attrs) do
    medium
    |> Medium.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a medium.

  ## Examples

      iex> delete_medium(medium)
      {:ok, %Medium{}}

      iex> delete_medium(medium)
      {:error, %Ecto.Changeset{}}

  """
  def delete_medium(%Medium{} = medium) do
    Repo.delete(medium)
  end

  def delete_media_by_path(path) do
    Repo.delete_all(from m in Medium, where: m.path == ^path)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking medium changes.

  ## Examples

      iex> change_medium(medium)
      %Ecto.Changeset{data: %Medium{}}

  """
  def change_medium(%Medium{} = medium, attrs \\ %{}) do
    Medium.changeset(medium, attrs)
  end

  def create_or_update_medium_by_path!(path) do
    medium = get_medium_by_path(path)

    attrs =
      case get_library_by_path(path) do
        nil ->
          raise ArgumentError, "No library found for #{inspect(path)}"

        library ->
          %{
            name: Path.basename(path),
            path: path,
            extension: Path.extname(path),
            video_codec: "hardcoded",
            library_id: Map.get(library, :id)
          }
      end

    case medium do
      nil ->
        create_medium(attrs)

      medium ->
        update_medium(medium, attrs)
    end
  end

  @spec start_monitoring :: :error | :ok
  def start_monitoring() do
    dirs =
      Repo.all(
        from l in Library,
          select: l.path
      )

    case Transcoderr.FilesystemConsumer.start(dirs: dirs) do
      {:ok, _pid} -> :ok
      _ -> :error
    end
  end

  @spec stop_monitoring :: :ok | {:error, :not_found}
  def stop_monitoring() do
    Transcoderr.FilesystemConsumer.stop()
  end

  @spec restart_monitoring :: :error | :ok
  def restart_monitoring() do
    stop_monitoring()
    start_monitoring()
  end
end
