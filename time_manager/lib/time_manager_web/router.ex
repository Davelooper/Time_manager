defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router
  # import TimeManagerWeb.UserController

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {TimeManagerWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TimeManagerWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
  end

  # Other scopes may use custom stacks.
  scope "/api", TimeManagerWeb do
    pipe_through(:api)
    resources("/users", UserController, only: [:index, :create, :show, :update, :delete])
    # get "/users", UserController, :index

    resources("/clocks", ClockController, only: [:index, :update, :delete])
    get "/clocks/:userId", ClockController, :get_by_user_id
    post "/clocks/:userId", ClockController, :create
    get "/clock/:id", ClockController, :show

    # post "/clocks/:userId", ClockController, :create
    # pipe_through :api



    resources("/workingtime", WorkingTimeController,
      only: [:update, :delete]
    )
    get "workingtime/:userId", WorkingTimeController, :get_all_by_user_id
    get "workingtime/:userId/:id", WorkingTimeController, :get_one_by_user_id
    post "workingtime/:userId", WorkingTimeController, :create

    # get "/users/:userId", UserController,:read
    # ressources "/workingtimes", WorkingtimeController
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:time_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: TimeManagerWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
