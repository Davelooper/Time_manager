# defmodule TimeManagerWeb.ClockController do
#   use TimeManagerWeb, :controller

#   # alias TimeManagerWeb.Catalog
#   alias TimeManagerWeb.Catalog
#   alias TimeManagerWeb.Clocks

#   def read(conn, %{"userId" => userId}) do
#     clock = Catalog.get_clock_by_id(userId)
#     json(conn, %{clock: clock})
#   end

#   # def create(conn, _params) do
#   # end

#   # def update(conn, _params) do
#   # end

#   # def delete(conn, _params) do
#   # end

#   # Action pour lire les clocks d'un utilisateur spécifique
#   # def read(conn, %{"userId" => user_id}) do
#   #   # Vérification si l'utilisateur existe

#   #   with {:ok, user} <- Accounts.get_user(user_id),
#   #       {:ok, clocks} <- Clocks.get_clocks_for_user(user) do
#   #     render(conn, "read.json", clocks: clocks)
#   #   else
#   #     {:error, :not_found} ->
#   #       conn
#   #       |> put_status(:not_found)
#   #       |> render(MyAppWeb.ErrorView, :"404")

#   #     {:error, :forbidden} ->
#   #       conn
#   #       |> put_status(:forbidden)
#   #       |> render(MyAppWeb.ErrorView, :"403")
#   #   end
#   # end
# end
