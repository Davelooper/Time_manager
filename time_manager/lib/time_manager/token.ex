defmodule TimeManager.Token do
  use Joken.Config

  # Durée d'expiration du token (7 jours)
  @token_age_secs 7 * 86_400
  # Générer un JWT
  def generate(data) do
    id = Map.get(data, "id")
    email = Map.get(data, "email")

    if id == nil or email == nil do
      {:error, "ID ou email est manquant"}
    else
      claims = %{
        "id" => id,
        "email" => email,
        # Expiration à 7 jours
        "exp" => DateTime.to_unix(DateTime.add(DateTime.utc_now(), @token_age_secs, :second))
      }

      # Générer et signer le JWT avec le signer configuré
      case generate_and_sign(claims) do
        {:ok, token, _claims} ->
          {:ok, token}

        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  # Vérifier un JWT
  def verify(token) do
    case verify_and_validate(token) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end
end
