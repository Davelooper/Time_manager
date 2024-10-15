defmodule TimeManagerWeb.Plugs.AuthPlug do
  import Plug.Conn
  # Importation de Phoenix.Controller pour utiliser json/2
  import Phoenix.Controller
  alias TimeManager.Account.UserToken
  alias TimeManager.Repo
  alias TimeManager.Token

  def init(default), do: default

  def call(conn, _default) do
    # Extraire le token du header "Authorization"
    authorization = get_req_header(conn, "authorization") |> List.first()

    # Vérifier que le header est présent et commence par "Bearer "
    case authorization do
      "Bearer " <> token ->
        # Vérifier si le token est valide en utilisant Token.verify/1
        case Token.verify(token) do
          {:ok, user} ->
            # Si le token est valide, on associe l'utilisateur au conn
            assign(conn, :current_user, user)

          {:error, reason} ->
            # Si le token est invalide, on renvoie une erreur 401
            conn
            |> put_status(:unauthorized)
            |> json(%{error: reason})
            |> halt()
        end

      _ ->
        # Si le header est absent ou mal formé, on renvoie une erreur 401
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Missing or invalid Authorization header"})
        |> halt()
    end
  end

  # Vérification du token en appelant la fonction `verify_session_token_query/1`
  defp verify_token(nil), do: {:error, :no_token}
  defp verify_token(_), do: {:error, :invalid_token_format}
end
