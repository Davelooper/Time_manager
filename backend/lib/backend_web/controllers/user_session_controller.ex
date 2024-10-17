defmodule BackendWeb.UserSessionController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Token

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        # Renvoyer un message d'erreur en JSON en cas d'échec de connexion
        conn
        |> put_status(:unauthorized)  # Statut 401 Unauthorized
        |> json(%{success: false, message: "Invalid email or password"})

      user ->
        case Token.generate_token(%{"id" => user.id, "email" => user.email}) do
          {:ok, token} ->
            # Renvoyer un token JWT en JSON
            json(conn, %{success: true, token: token})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)  # Statut 500 Internal Server Error
            |> json(%{success: false, message: "Error generating token: #{reason}"})
        end
    end
  end
end
