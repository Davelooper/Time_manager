defmodule BackendWeb.Router do
  use BackendWeb, :router

  import BackendWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/users", UserController, :create
    post "/users/log_in", UserSessionController, :create

    resources "/teams", TeamController, except: [:new, :edit]

    resources "/working_times", WorkingTimeController, except: [:new, :edit]
    get("workingtime/:userId", WorkingTimeController, :get_all_by_user_id)
    get("workingtime/:userId/:id", WorkingTimeController, :get_one_by_user_id)
    post("workingtime/:userId", WorkingTimeController, :create)

    resources "/clocks", ClockController, except: [:new, :edit]
    get("/clocks/:userId", ClockController, :get_by_user_id)
    post("/clocks/:userId", ClockController, :create)
    get("/clock/:id", ClockController, :show)

  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:backend, :dev_routes) do



    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

end
