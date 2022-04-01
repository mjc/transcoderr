defmodule Transcoderr.LibrariesTest do
  use Transcoderr.DataCase

  alias Transcoderr.Libraries

  describe "libraries" do
    alias Transcoderr.Libraries.Library

    import Transcoderr.LibrariesFixtures

    @invalid_attrs %{name: nil, path: nil}

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert Libraries.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert Libraries.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      valid_attrs = %{name: "some name", path: "some path"}

      assert {:ok, %Library{} = library} = Libraries.create_library(valid_attrs)
      assert library.name == "some name"
      assert library.path == "some path"
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Libraries.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      update_attrs = %{name: "some updated name", path: "some updated path"}

      assert {:ok, %Library{} = library} = Libraries.update_library(library, update_attrs)
      assert library.name == "some updated name"
      assert library.path == "some updated path"
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

    import Transcoderr.LibrariesFixtures

    @invalid_attrs %{extension: nil, name: nil, path: nil, video_codec: nil}

    test "list_media/0 returns all media" do
      medium = medium_fixture()
      assert Libraries.list_media() == [medium]
    end

    test "get_medium!/1 returns the medium with given id" do
      medium = medium_fixture()
      assert Libraries.get_medium!(medium.id) == medium
    end

    test "create_medium/1 with valid data creates a medium" do
      valid_attrs = %{extension: "some extension", name: "some name", path: "some path", video_codec: "some video_codec"}

      assert {:ok, %Medium{} = medium} = Libraries.create_medium(valid_attrs)
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
      update_attrs = %{extension: "some updated extension", name: "some updated name", path: "some updated path", video_codec: "some updated video_codec"}

      assert {:ok, %Medium{} = medium} = Libraries.update_medium(medium, update_attrs)
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
