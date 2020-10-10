defmodule TranscoderrWeb.PageLive do
  use TranscoderrWeb, :live_view

  @content_menu %{
    general: %{
      index: 0,
      label: "General",
      items: %{
        dashboard: %{active: false, url: "#"},
        setup: %{active: false, url: "#"},
      }
    },
    community: %{
      index: 1,
      label: "Community",
      items: %{
        github: %{active: false, url: "#"},
        discord: %{active: false, url: "#"},
        forums: %{active: false, url: "#"}
      }
    },
   extras: %{
      index: 2,
      label: "Extras",
      items: %{
        plugins: %{active: false, url: "#"},
        themes: %{active: false, url: "#"},
        magic: %{active: false, url: "#"}
      }
    },
  }

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign_defaults(socket, params)}
  end

  def assign_defaults(socket, _params) do
    socket
    |> assign(:content_menu, @content_menu)
    |> assign(:page_title, "A page title")
  end
end
