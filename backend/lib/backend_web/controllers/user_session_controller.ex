defmodule BackendWeb.UserSessionController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Token

  def create(conn, params) do
    email = Map.get(params, "email")
    password = Map.get(params, "password")

    if(email == nil || password == nil) do
      conn
      |> put_status(:bad_request)
      |> json(%{success: false, message: "Email and password are required"})
    end

    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        # Renvoyer un message d'erreur en JSON en cas d'échec de connexion
        conn
        # Statut 401 Unauthorized
        |> put_status(:unauthorized)
        |> json(%{success: false, message: "Invalid email or password"})

      user ->
        case Token.generate_token(%{
               "id" => user.id,
               "email" => user.email,
               "role" => user.role,
               "team_id" => user.team_id,
               "username" => user.username
             }) do
          {:ok, token} ->
            # Renvoyer un token JWT en JSON
            json(conn, %{success: true, token: token})

          {:error, reason} ->
            conn
            # Statut 500 Internal Server Error
            |> put_status(:internal_server_error)
            |> json(%{success: false, message: "Error generating token: #{reason}"})
        end
    end
  end

  def create_webauthn_session(conn, %{"token" => %{"code" => token}}) do
    case Accounts.get_user_by_webauthn_token(token) do
      {:ok, user} ->
        case Token.generate_token(%{
               "id" => user.id,
               "email" => user.email,
               "role" => user.role,
               "team_id" => user.team_id,
               "username" => user.username
             }) do
          {:ok, jwt_token} ->
            json(conn, %{success: true, token: jwt_token})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{success: false, message: "Error generating token: #{reason}"})
        end

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false, message: "Invalid WebAuthn token"})
    end
  end

end
