defmodule BackendWeb.FallbackController do
  use BackendWeb, :controller

  # Gestion des erreurs pour les changesets Ecto
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: BackendWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # Gestion des erreurs pour les ressources non trouvées
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: BackendWeb.ErrorJSON)
    |> render(:"404")
  end

  # Nouvelle clause pour gérer les erreurs génériques de type map
  def call(conn, {:error, %{"error" => message}}) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: message})
  end
end
