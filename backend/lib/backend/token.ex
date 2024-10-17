defmodule Backend.Token do
  use Joken.Config

  # Durée d'expiration du token (7 jours)
  @token_age_secs 7 * 86_400

  def generate_token(data) do
    # Utilisation d'atomes comme clé après Map.from_struct
    id = Map.get(data, :id)
    email = Map.get(data, :email)
    role = Map.get(data, :role)
    team_id = Map.get(data, :team_id)
    username = Map.get(data, :username)

    if is_nil(id) or is_nil(email) do
      {:error, %{"error" => "ID ou email est manquant"}}
    else
      claims = %{
        "id" => id,
        "email" => email,
        "role" => role,
        "team_id" => team_id,
        "username" => username,
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
