defmodule BackendWeb.Router do
  use BackendWeb, :router

  import BackendWeb.UserAuth

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(BackendWeb.Plugs.AuthPlug)
  end

  scope "/api", BackendWeb do
    pipe_through(:api)

    get("/users/verifyToken", UserController, :userVerifyToken)
    post("/users/log_in", UserController, :userLogin)
    post("/users", UserController, :create)
    # resources("/users", UserController, except: [:new, :edit])
    post("/users/webauths", UserSessionController, :create_webauthn_session)
    post("/users/webauths/:userId", UserSessionController, :generate_webauthtoken)
    get("/users/:userId", UserController, :show)
    get("/users/team/:teamId", UserController, :get_all_by_team_id)
    put("/users/:userId", UserController, :update)
    delete("/users/:userId", UserController, :delete)

    resources("/teams", TeamController, except: [:new, :edit])

    # resources "/workingtime", WorkingTimeController, except: [:new, :edit]
    get("workingtime/:teamId/:id", WorkingTimeController, :get_one_by_user_id)
    get("workingtime/:teamId", WorkingTimeController, :get_all_by_team_id)
    put("workingtime/:id", WorkingTimeController, :update)
    post("workingtime/:teamId", WorkingTimeController, :create)
    delete("workingtime/:id", WorkingTimeController, :delete)

    # resources("/clocks", ClockController, except: [:new, :edit])
    get("/clocks/:userId", ClockController, :get_by_user_id)
    post("/clocks/:userId", ClockController, :create)
    delete("/clocks/:id", ClockController, :delete)
    put("clocks/:id", ClockController, :update)
    get("/clock/:id", ClockController, :show)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:backend, :dev_routes) do
    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
