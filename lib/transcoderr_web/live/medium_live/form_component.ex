defmodule TranscoderrWeb.MediumLive.FormComponent do
  use TranscoderrWeb, :live_component

  alias Transcoderr.Libraries

  @impl true
  def update(%{medium: medium} = assigns, socket) do
    changeset = Libraries.change_medium(medium)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"medium" => medium_params}, socket) do
    changeset =
      socket.assigns.medium
      |> Libraries.change_medium(medium_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"medium" => medium_params}, socket) do
    save_medium(socket, socket.assigns.action, medium_params)
  end

  defp save_medium(socket, :edit, medium_params) do
    case Libraries.update_medium(socket.assigns.medium, medium_params) do
      {:ok, _medium} ->
        {:noreply,
         socket
         |> put_flash(:info, "Medium updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_medium(socket, :new, medium_params) do
    case Libraries.create_medium(medium_params) do
      {:ok, _medium} ->
        {:noreply,
         socket
         |> put_flash(:info, "Medium created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
