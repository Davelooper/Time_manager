defmodule Backend.Token do
  use Joken.Config

  # Durée d'expiration du token (7 jours)
  @token_age_secs 7 * 86_400

  def generate_token(data) do
    id = Map.get(data, "id")
    email = Map.get(data, "email")

    if id == nil or email == nil do
      {:error, %{"error" => "ID ou email est manquant"}}
    else
      claims = %{
        "id" => id,
        "email" => email,
        "exp" => DateTime.to_unix(DateTime.add(DateTime.utc_now(), @token_age_secs, :second))
      }

      case generate_and_sign(claims) do
        {:ok, token, _claims} ->
          {:ok, token}

        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  def verify(token) do
    case verify_and_validate(token) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end
end
