defmodule Transcoderr.LibrariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Transcoderr.Libraries` context.
  """

  @doc """
  Generate a library.
  """
  def library_fixture(attrs \\ %{}) do
    {:ok, library} =
      attrs
      |> Enum.into(%{
        name: "some name",
        path: "some path"
      })
      |> Transcoderr.Libraries.create_library()

    library
  end

  @doc """
  Generate a medium.
  """
  def medium_fixture(attrs \\ %{}) do
    {:ok, medium} =
      attrs
      |> Enum.into(%{
        extension: "some extension",
        name: "some name",
        path: "some path",
        video_codec: "some video_codec"
      })
      |> Transcoderr.Libraries.create_medium()

    medium
  end
end
