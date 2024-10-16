defmodule BackendWeb.Router do
  use BackendWeb, :router

  import BackendWeb.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]

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


  ## Authentication routes

  scope "/", BackendWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", BackendWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", BackendWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
