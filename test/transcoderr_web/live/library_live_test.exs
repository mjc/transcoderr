defmodule TranscoderrWeb.LibraryLiveTest do
  use TranscoderrWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Transcoderr.Libraries

  @priv_path to_string(:code.priv_dir(:transcoderr))
  @repo_path Path.join(@priv_path, "repo")
  @create_attrs %{name: "some name", path: @priv_path}
  @update_attrs %{name: "some updated name", path: @repo_path}
  @invalid_attrs %{name: nil, path: nil}

  defp fixture(:library) do
    {:ok, library} = Libraries.create_library(@create_attrs)
    library
  end

  defp create_library(_) do
    library = fixture(:library)
    %{library: library}
  end

  describe "Index" do
    setup [:create_library]

    test "lists all libraries", %{conn: conn, library: library} do
      {:ok, _index_live, html} = live(conn, Routes.library_index_path(conn, :index))

      assert html =~ "Listing Libraries"
      assert html =~ library.name
    end

    @tag :skip
    test "saves new library", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.library_index_path(conn, :index))

      assert index_live |> element("a", "New Library") |> render_click() =~
               "New Library"

      assert_patch(index_live, Routes.library_index_path(conn, :new))

      assert index_live
             |> form("#library-form", library: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#library-form", library: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_index_path(conn, :index))

      assert html =~ "Library created successfully"
      assert html =~ "some name"
    end

    test "updates library in listing", %{conn: conn, library: library} do
      {:ok, index_live, _html} = live(conn, Routes.library_index_path(conn, :index))

      assert index_live |> element("#library-#{library.id} a", "Edit") |> render_click() =~
               "Edit Library"

      assert_patch(index_live, Routes.library_index_path(conn, :edit, library))

      # @pending
      # assert index_live
      #        |> form("#library-form", library: @invalid_attrs)
      #        |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#library-form", library: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_index_path(conn, :index))

      assert html =~ "Library updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes library in listing", %{conn: conn, library: library} do
      {:ok, index_live, _html} = live(conn, Routes.library_index_path(conn, :index))

      assert index_live |> element("#library-#{library.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#library-#{library.id}")
    end
  end

  describe "Show" do
    setup [:create_library]

    test "displays library", %{conn: conn, library: library} do
      {:ok, _show_live, html} = live(conn, Routes.library_show_path(conn, :show, library))

      assert html =~ "Show Library"
      assert html =~ library.name
    end

    test "updates library within modal", %{conn: conn, library: library} do
      {:ok, show_live, _html} = live(conn, Routes.library_show_path(conn, :show, library))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Library"

      assert_patch(show_live, Routes.library_show_path(conn, :edit, library))

      # @pending
      # assert show_live
      #        |> form("#library-form", library: @invalid_attrs)
      #        |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#library-form", library: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_show_path(conn, :show, library))

      assert html =~ "Library updated successfully"
      assert html =~ "some updated name"
    end
  end
end
