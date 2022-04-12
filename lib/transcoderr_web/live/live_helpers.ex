defmodule TranscoderrWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `TranscoderrWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, TranscoderrWeb.LibraryLive.FormComponent,
        id: @library.id || :new,
        action: @live_action,
        library: @library,
        return_to: Routes.library_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(TranscoderrWeb.ModalComponent, modal_opts)
  end

  def truncate_middle(path, max_length \\ 50) do
    path_len = String.length(path)

    if path_len > max_length do
      half_max_length = div(max_length, 2)
      path_split_at = div(path_len, 2) |> min(half_max_length)
      {head, tail} = String.split_at(path, path_split_at - 3)
      {_, tail} = String.split_at(tail, -path_split_at)
      Enum.join([head, "...", tail], "")
    else
      path
    end
  end
end
