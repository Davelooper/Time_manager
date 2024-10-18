defmodule Backend.UserTest do
  use ExUnit.Case, async: true
  alias Backend.Accounts.User

  @valid_attrs %{
    email: "user@example.com",
    password: "valid_password123",
    role: "user",
    team_id: Ecto.UUID.generate(),
    username: "user_example"
  }

  @invalid_email_attrs Map.put(@valid_attrs, :email, "invalid_email")

  @short_password_attrs Map.put(@valid_attrs, :password, "short")

  describe "changeset/2" do
    test "creates a valid changeset with all required fields" do
      changeset = User.changeset(%User{}, @valid_attrs)

      assert changeset.valid?
      assert changeset.changes.email == @valid_attrs[:email]
      assert changeset.changes.username == @valid_attrs[:username]
      assert changeset.changes.team_id == @valid_attrs[:team_id]
      assert changeset.changes.role == @valid_attrs[:role]
    end

    test "requires all mandatory fields" do
      changeset = User.changeset(%User{}, %{})

      refute changeset.valid?
      assert %{email: ["can't be blank"], password: ["can't be blank"], role: ["can't be blank"], team_id: ["can't be blank"], username: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates email format" do
      changeset = User.changeset(%User{}, @invalid_email_attrs)

      refute changeset.valid?
      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates password length (minimum)" do
      changeset = User.changeset(%User{}, @short_password_attrs)

      refute changeset.valid?
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    end
  end

  describe "password_changeset/3" do
    test "validates password confirmation" do
      attrs = Map.put(@valid_attrs, :password_confirmation, "different_password")
      changeset = User.password_changeset(%User{}, attrs)

      refute changeset.valid?
      assert %{password_confirmation: ["does not match password"]} = errors_on(changeset)
    end

    test "hashes the password when valid" do
      changeset = User.password_changeset(%User{}, @valid_attrs)

      assert changeset.valid?
      assert changeset.changes.hashed_password
      refute changeset.changes.password
    end
  end

  describe "confirm_changeset/1" do
    test "sets confirmed_at to the current time" do
      user = %User{}
      changeset = User.confirm_changeset(user)

      assert changeset.valid?
      assert changeset.changes.confirmed_at
      assert changeset.changes.confirmed_at <= DateTime.utc_now()
    end
  end

  describe "valid_password?/2" do
    test "returns true when the password is valid" do
      password = "valid_password123"
      user = %User{hashed_password: Bcrypt.hash_pwd_salt(password)}

      assert User.valid_password?(user, password)
    end

    test "returns false when the password is invalid" do
      password = "valid_password123"
      user = %User{hashed_password: Bcrypt.hash_pwd_salt(password)}

      refute User.valid_password?(user, "wrong_password")
    end
  end

  describe "validate_current_password/2" do
    test "returns valid changeset if the current password is correct" do
      user = %User{hashed_password: Bcrypt.hash_pwd_salt("valid_password123")}
      changeset = User.validate_current_password(%User{}, "valid_password123")

      assert changeset.valid?
    end

    test "adds an error to the changeset if the current password is incorrect" do
      user = %User{hashed_password: Bcrypt.hash_pwd_salt("valid_password123")}
      changeset = User.validate_current_password(%User{}, "wrong_password")

      refute changeset.valid?
      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end
  end
end
