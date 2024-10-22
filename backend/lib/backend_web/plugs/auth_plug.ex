defmodule BackendWeb.Plugs.AuthPlug do
  import Plug.Conn
  # Importation de Phoenix.Controller pour utiliser json/2
  import Phoenix.Controller
  alias Backend.Account.UserToken
  alias Backend.Repo
  alias Backend.Token

  def init(default), do: default

  def call(conn, _default) do
    authorization = get_req_header(conn, "authorization") |> List.first()

    case authorization do
      "Bearer " <> token ->
        # Vérifier si le token est valide en utilisant Token.verify/1
        case Token.verify(token) do
          # Si le token est valide
          {:ok, claims} ->
            # Assigner l'ID utilisateur extrait du token
            IO.inspect(claims);
            conn
            |> assign(:current_user, claims)

          # Si le token est invalide
          {:error, reason} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid token"})
            |> halt()
        end

      _ ->
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
