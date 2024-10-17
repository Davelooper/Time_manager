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
         # Convertir en map
         user_map = Map.from_struct(user),
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

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
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

  def userVerifyToken(conn, params) do
    ## Return ok car le middleware AuthPlug vérifie déjà le token
    conn
    |> put_status(:ok)
    |> json(%{message: "Token is valid"})
  end
end
