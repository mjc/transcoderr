defmodule TranscoderrWeb.MediumLive.Index do
  use TranscoderrWeb, :live_view

  alias Transcoderr.Libraries
  alias Transcoderr.Libraries.Medium

  @impl true
  def mount(_params, _session, socket) do
    Libraries.LiveUpdate.subscribe_live_view()

    {:ok, assign(socket, :media, list_media())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Medium")
    |> assign(:medium, Libraries.get_medium!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Medium")
    |> assign(:medium, %Medium{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Media")
    |> assign(:medium, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    medium = Libraries.get_medium!(id)
    {:ok, _} = Libraries.delete_medium(medium)

    {:noreply, assign(socket, :media, list_media())}
  end

  @impl true
  def handle_info(
        {_requesting_module, [:media, :updated], medium},
        %{assigns: %{media: media}} = socket
      ) do
    IO.inspect(medium, label: "media updated")
    {:noreply, assign(socket, :media, (media ++ [medium]) |> Enum.uniq())}
  end

  def handle_info(
        {_requesting_module, [:media, :removed], removed_path},
        %{assigns: %{media: media}} = socket
      ) do
    media =
      Enum.filter(media, fn %{path: path} ->
        path != removed_path
      end)

    {:noreply, assign(socket, :media, media)}
  end

  defp list_media do
    Libraries.list_media()
  end
end
