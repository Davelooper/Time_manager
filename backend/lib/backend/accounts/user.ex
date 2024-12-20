defmodule Backend.Accounts.User do
  alias Backend.Repo
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:current_password, :string, virtual: true, redact: true)
    field(:confirmed_at, :utc_datetime)
    field(:role, :string)
    field(:team_id, Ecto.UUID)
    field(:username, :string)
    field(:web_auth_token, :string)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    # Inclure :password
    |> cast(attrs, [:email, :role, :team_id, :username, :password])
    |> validate_required([:email, :password, :role, :team_id, :username])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    # Passer les options correctement
    |> maybe_hash_password(hash_password: true)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Backend.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(user, password) do
    Bcrypt.verify_pass(password, user.hashed_password)
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    changeset = cast(changeset, %{current_password: password}, [:current_password])

    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def verify_webauthn_token(user, credential_data) do
    if user.web_auth_token == credential_data["id"] do
      true
    else
      false
    end
  end

  @doc """
  Changeset pour la mise à jour d'un utilisateur.
  """
  def update_changeset(user, attrs) do
    # Définissez les champs autorisés à être mis à jour
    # Ajoutez d'autres champs si nécessaire
    allowed_fields = [:email, :username, :role, :team_id]

    user
    |> cast(attrs, allowed_fields)
    |> validate_optional_fields(attrs)
  end

  defp validate_optional_fields(changeset, attrs) do
    changeset
    |> maybe_validate_length(:name, attrs, min: 2)
    |> maybe_validate_format(:email, attrs, ~r/@/)
    |> maybe_validate_length(:username, attrs, min: 3)

    # Ajoutez d'autres validations si nécessaire
  end

  defp maybe_validate_length(changeset, field, attrs, opts) do
    if Map.has_key?(attrs, Atom.to_string(field)) do
      validate_length(changeset, field, opts)
    else
      changeset
    end
  end

  defp maybe_validate_format(changeset, field, attrs, regex) do
    if Map.has_key?(attrs, Atom.to_string(field)) do
      validate_format(changeset, field, regex)
    else
      changeset
    end
  end
end
