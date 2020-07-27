defmodule TranscoderrWeb.MediumLive.Show do
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
     |> assign(:medium, Libraries.get_medium!(id))}
  end

  defp page_title(:show), do: "Show Medium"
  defp page_title(:edit), do: "Edit Medium"
end
