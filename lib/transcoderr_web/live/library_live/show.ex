defmodule TranscoderrWeb.LibraryLive.Show do
  use TranscoderrWeb, :live_view

  alias Transcoderr.Libraries

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:library, Libraries.get_library!(id))}
  end

  defp page_title(:show), do: "Show Library"
  defp page_title(:edit), do: "Edit Library"
end
