defmodule BackendWeb.Plugs.IsAdminPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Backend.Account.UserToken
  alias Backend.Repo
  alias Backend.Token

  def init(default), do: default

  def call(conn, _default) do
    current_user = conn.assigns.current_user;
    if current_user["role"] == "admin" do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
      |> halt()
    end

  end

end
