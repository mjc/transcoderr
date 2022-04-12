defmodule TranscoderrWeb.Router do
  use TranscoderrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TranscoderrWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TranscoderrWeb do
    pipe_through :browser

    live "/libraries", LibraryLive.Index, :index
    live "/libraries/new", LibraryLive.Index, :new
    live "/libraries/:id/edit", LibraryLive.Index, :edit

    live "/libraries/:id", LibraryLive.Show, :show
    live "/libraries/:id/show/edit", LibraryLive.Show, :edit

    live "/media", MediumLive.Index, :index
    live "/media/new", MediumLive.Index, :new
    live "/media/:id/edit", MediumLive.Index, :edit

    live "/media/:id", MediumLive.Show, :show
    live "/media/:id/show/edit", MediumLive.Show, :edit

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TranscoderrWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: TranscoderrWeb.Telemetry,
        ecto_psql_extras_options: [long_running_queries: [threshold: "200 milliseconds"]],
        additional_pages: [
          broadway: BroadwayDashboard
        ]
    end
  end
end
