defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Account
  alias TimeManager.Account.User

  # Appliquer le plug d'authentification uniquement sur certaines actions
  plug(
    TimeManagerWeb.Plugs.AuthPlug
    when action in [:show, :index, :indexAll, :update, :delete, :userVerifyToken]
  )

  action_fallback(TimeManagerWeb.FallbackController)

  # Get all users
  def indexAll(conn, _params) do
    users = Account.list_users()
    render(conn, :index, users: users)
  end

  def index(conn, params) do
    email = Map.get(params, "email", nil)
    username = Map.get(params, "username", nil)

    if(is_nil(email) and is_nil(username)) do
      conn
      |> put_status(:bad_request)
      |> json(%{message: "You must provide an email and a username"})
    end

    users = Account.getUserFromMailAndUsername(email, username)
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user.id}")
        |> json(%{message: "User created successfully"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Could not create user", errors: changeset.errors})
    end
  end

  def show(conn, %{"id" => id}) do
    user =
      Account.get_user!(id)

    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user =
      Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user =
      Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
  Connecte l'utilisateur en vérifiant l'email et le mot de passe, et renvoie un token JWT.
  """
  def userLogin(conn, params) do
    email = Map.get(params, "email")
    password = Map.get(params, "password")

    if(is_nil(email) or is_nil(password)) do
      conn
      |> put_status(:bad_request)
      |> json(%{error: "You must provide an email and a password"})
    end

    case Account.verify_user_password_by_email(email, password) do
      {:ok, user} ->
        case Account.generateUserToken(user) do
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

  @doc """
  Vérifie si le token JWT de l'utilisateur est toujours valide/actif.
  """
  def userVerifyToken(conn, params) do
    ## Return ok car le middleware AuthPlug vérifie déjà le token
    conn
    |> put_status(:ok)
    |> json(%{message: "Token is valid"})
  end
end
