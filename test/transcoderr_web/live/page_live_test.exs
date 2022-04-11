defmodule TranscoderrWeb.PageLiveTest do
  use TranscoderrWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "<p class=\"title\">Transcoderr</p>"
    assert render(page_live) =~ "<h1 class=\"title\">Welcome to Transcoderr!</h1>"
  end
end
