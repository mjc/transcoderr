defmodule Transcoderr.LibrariesTest do
  use Transcoderr.DataCase

  alias Transcoderr.Libraries

  describe "libraries" do
    alias Transcoderr.Libraries.Library

    @priv_path to_string(:code.priv_dir(:transcoderr))
    @repo_path Path.join(@priv_path, "repo")
    @valid_attrs %{name: "some name", path: @priv_path}
    @update_attrs %{name: "some updated name", path: @repo_path}
    @invalid_attrs %{name: nil, path: nil}

    def library_fixture(attrs \\ %{}) do
      {:ok, library} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Libraries.create_library()

      library
    end

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert Libraries.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert Libraries.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      assert {:ok, %Library{} = library} = Libraries.create_library(@valid_attrs)
      assert library.name == "some name"
      assert library.path == @priv_path
    end

    test "create_library/1 with invalid path returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Libraries.create_library(%{path: "/nonexistent"})
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Libraries.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      assert {:ok, %Library{} = library} = Libraries.update_library(library, @update_attrs)
      assert library.name == "some updated name"
      assert library.path == @repo_path
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = Libraries.update_library(library, @invalid_attrs)
      assert library == Libraries.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = Libraries.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> Libraries.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = Libraries.change_library(library)
    end
  end

  describe "media" do
    alias Transcoderr.Libraries.Medium

    @valid_attrs %{
      extension: "some extension",
      name: "some name",
      path: "some path",
      video_codec: "some video_codec"
    }
    @update_attrs %{
      extension: "some updated extension",
      name: "some updated name",
      path: "some updated path",
      video_codec: "some updated video_codec"
    }
    @invalid_attrs %{extension: nil, name: nil, path: nil, video_codec: nil}

    def medium_fixture(attrs \\ %{}) do
      priv_path = to_string(:code.priv_dir(:transcoderr))
      create_attrs = %{name: "some name", path: priv_path}
      {:ok, library} = Libraries.create_library(create_attrs)
      create_medium_attrs = Map.put(@valid_attrs, :library_id, library.id)

      {:ok, medium} =
        attrs
        |> Enum.into(create_medium_attrs)
        |> Libraries.create_medium()

      medium
    end

    test "list_media/0 returns all media" do
      medium = medium_fixture()
      assert Libraries.list_media() == [medium]
    end

    test "get_medium!/1 returns the medium with given id" do
      medium = medium_fixture()
      assert Libraries.get_medium!(medium.id) == medium
    end

    test "create_medium/1 with valid data creates a medium" do
      priv_path = to_string(:code.priv_dir(:transcoderr))
      create_attrs = %{name: "some name", path: priv_path}
      {:ok, library} = Libraries.create_library(create_attrs)
      create_medium_attrs = Map.put(@valid_attrs, :library_id, library.id)
      assert {:ok, %Medium{} = medium} = Libraries.create_medium(create_medium_attrs)
      assert medium.extension == "some extension"
      assert medium.name == "some name"
      assert medium.path == "some path"
      assert medium.video_codec == "some video_codec"
    end

    test "create_medium/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Libraries.create_medium(@invalid_attrs)
    end

    test "update_medium/2 with valid data updates the medium" do
      medium = medium_fixture()
      assert {:ok, %Medium{} = medium} = Libraries.update_medium(medium, @update_attrs)
      assert medium.extension == "some updated extension"
      assert medium.name == "some updated name"
      assert medium.path == "some updated path"
      assert medium.video_codec == "some updated video_codec"
    end

    test "update_medium/2 with invalid data returns error changeset" do
      medium = medium_fixture()
      assert {:error, %Ecto.Changeset{}} = Libraries.update_medium(medium, @invalid_attrs)
      assert medium == Libraries.get_medium!(medium.id)
    end

    test "delete_medium/1 deletes the medium" do
      medium = medium_fixture()
      assert {:ok, %Medium{}} = Libraries.delete_medium(medium)
      assert_raise Ecto.NoResultsError, fn -> Libraries.get_medium!(medium.id) end
    end

    test "change_medium/1 returns a medium changeset" do
      medium = medium_fixture()
      assert %Ecto.Changeset{} = Libraries.change_medium(medium)
    end
  end
end
