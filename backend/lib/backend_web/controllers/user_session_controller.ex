defmodule BackendWeb.UserSessionController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias BackendWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        # En cas d'échec de l'authentification, renvoyer un message d'erreur JSON.
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})

      user ->
        # Générer un token JWT pour l'utilisateur authentifié.
        token = Backend.Token.generate_token(user)

        # Renvoyer une réponse JSON avec le token.
        conn
        |> json(%{message: "Welcome back!", token: token})
    end
  end


  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
