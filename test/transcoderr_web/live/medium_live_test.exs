defmodule TranscoderrWeb.MediumLiveTest do
  use TranscoderrWeb.ConnCase

  import Phoenix.LiveViewTest
  import Transcoderr.LibrariesFixtures

  @create_attrs %{extension: "some extension", name: "some name", path: "some path", video_codec: "some video_codec"}
  @update_attrs %{extension: "some updated extension", name: "some updated name", path: "some updated path", video_codec: "some updated video_codec"}
  @invalid_attrs %{extension: nil, name: nil, path: nil, video_codec: nil}

  defp create_medium(_) do
    medium = medium_fixture()
    %{medium: medium}
  end

  describe "Index" do
    setup [:create_medium]

    test "lists all media", %{conn: conn, medium: medium} do
      {:ok, _index_live, html} = live(conn, Routes.medium_index_path(conn, :index))

      assert html =~ "Listing Media"
      assert html =~ medium.extension
    end

    test "saves new medium", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.medium_index_path(conn, :index))

      assert index_live |> element("a", "New Medium") |> render_click() =~
               "New Medium"

      assert_patch(index_live, Routes.medium_index_path(conn, :new))

      assert index_live
             |> form("#medium-form", medium: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#medium-form", medium: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.medium_index_path(conn, :index))

      assert html =~ "Medium created successfully"
      assert html =~ "some extension"
    end

    test "updates medium in listing", %{conn: conn, medium: medium} do
      {:ok, index_live, _html} = live(conn, Routes.medium_index_path(conn, :index))

      assert index_live |> element("#medium-#{medium.id} a", "Edit") |> render_click() =~
               "Edit Medium"

      assert_patch(index_live, Routes.medium_index_path(conn, :edit, medium))

      assert index_live
             |> form("#medium-form", medium: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#medium-form", medium: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.medium_index_path(conn, :index))

      assert html =~ "Medium updated successfully"
      assert html =~ "some updated extension"
    end

    test "deletes medium in listing", %{conn: conn, medium: medium} do
      {:ok, index_live, _html} = live(conn, Routes.medium_index_path(conn, :index))

      assert index_live |> element("#medium-#{medium.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#medium-#{medium.id}")
    end
  end

  describe "Show" do
    setup [:create_medium]

    test "displays medium", %{conn: conn, medium: medium} do
      {:ok, _show_live, html} = live(conn, Routes.medium_show_path(conn, :show, medium))

      assert html =~ "Show Medium"
      assert html =~ medium.extension
    end

    test "updates medium within modal", %{conn: conn, medium: medium} do
      {:ok, show_live, _html} = live(conn, Routes.medium_show_path(conn, :show, medium))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Medium"

      assert_patch(show_live, Routes.medium_show_path(conn, :edit, medium))

      assert show_live
             |> form("#medium-form", medium: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#medium-form", medium: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.medium_show_path(conn, :show, medium))

      assert html =~ "Medium updated successfully"
      assert html =~ "some updated extension"
    end
  end
end
