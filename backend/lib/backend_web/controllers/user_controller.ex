defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Accounts
  alias Backend.Accounts.User
  alias Backend.Token
  action_fallback(BackendWeb.FallbackController)

  plug(
    BackendWeb.Plugs.AuthPlug
    when action in [:show, :index, :indexAll, :update, :delete, :userVerifyToken]
  )

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         user_map = Map.from_struct(user) |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end),
         {:ok, token} <- Token.generate_token(user_map) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> json(%{
        id: user.id,
        email: user.email,
        username: user.username,
        role: user.role,
        # Ajout du token dans la réponse JSON
        token: token
      })
    end
  end

  def show(conn, params) do
    id = Map.get(params, "id")

    if is_nil(id) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Missing id parameter"})
    else
      user = Accounts.get_user!(id)
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def userVerifyToken(conn, _params) do
    # Si le token est valide (vérifié par le plug d'authentification), renvoyer une réponse réussie
    conn
    |> put_status(:ok)
    |> json(%{message: "Token is valid"})
  end

  def userLogin(conn, %{"email" => email, "password" => password}) do
    case Accounts.verify_user_password_by_email(email, password) do
      {:ok, user} ->
        user_map = Map.from_struct(user)

        case Accounts.generateUserToken(user_map) do
          {:ok, token} ->
            conn
            |> put_status(:ok)
            |> json(%{token: token})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: reason})
        end

      :error ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end
end
