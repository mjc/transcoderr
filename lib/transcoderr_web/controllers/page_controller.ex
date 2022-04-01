defmodule TranscoderrWeb.PageController do
  use TranscoderrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
