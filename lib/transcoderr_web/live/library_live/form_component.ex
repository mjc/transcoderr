defmodule TranscoderrWeb.LibraryLive.FormComponent do
  use TranscoderrWeb, :live_component

  alias Transcoderr.Libraries

  @impl true
  def update(%{library: library} = assigns, socket) do
    changeset = Libraries.change_library(library)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:perform_submit?, false)}
  end

  @impl true

  def handle_event("validate", %{"library" => %{"path" => path} = library_params}, socket) do
    changeset =
      socket.assigns.library
      |> Libraries.change_library(library_params)
      |> Map.put(:action, :validate)

    directories = list_directories(path)

    {
      :noreply,
      socket
      |> assign(:changeset, changeset)
      |> assign(:directories, directories)
      |> assign(:library_params, library_params)
    }
  end

  def handle_event("save", %{"value" => ""}, socket) do
    library_params = Map.get(socket.assigns, :library_params) || %{}
    save_library(socket, socket.assigns.action, library_params)
  end

  def handle_event("save", %{"library" => library_params}, socket) do
    save_library(socket, socket.assigns.action, library_params)
  end

  defp save_library(socket, :edit, library_params) do
    case Libraries.update_library(socket.assigns.library, library_params) do
      {:ok, library} ->
        if Map.get(library_params, "scan_on_save") do
          Libraries.scan_library(library)
        end

        {:noreply,
         socket
         |> put_flash(:info, "Library updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_library(socket, :new, library_params) do
    case Libraries.create_library(library_params) do
      {:ok, library} ->
        if Map.get(library_params, "scan_on_save") do
          Libraries.scan_library(library)
        end

        {:noreply,
         socket
         |> put_flash(:info, "Library created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp list_directories(path) do
    # @TODO review if this is safe to do with user input.
    case File.ls(path) do
      {:ok, entries} ->
        Enum.map(entries, fn entry -> Path.join(path, entry) end)
        |> Enum.take(25)

      {:error, _} ->
        []
    end
  end
end
