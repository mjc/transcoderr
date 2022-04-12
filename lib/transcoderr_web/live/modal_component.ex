defmodule TranscoderrWeb.ModalComponent do
  use TranscoderrWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id="{@id}" class="modal is-active"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={"##{@id}"}
      phx-page-loading>
      <div class="modal-background"></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title"><%= @opts[:title] %></p>

          <%= live_patch to: @return_to, class: "phx-modal-close" do %>
            <button class="delete" aria-label="close"></button>
          <% end %>
        </header>
        <section class="modal-card-body">
          <%= live_component @component, @opts %>
        </section>
        <footer class="modal-card-foot">
          <p class="control">
            <%= if @opts[:save_button_target] do %>
              <button phx-click="save" phx-target={@opts[:save_button_target]} phx-disable-with="Saving..." class="button is-success">
              Save
              </button>
            <% end %>

            <%= live_patch to: @return_to, class: "phx-modal-close" do %>
              <button class="button">Cancel</button>
            <% end %>
          </p>
        </footer>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
