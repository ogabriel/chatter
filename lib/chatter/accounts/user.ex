defmodule Chatter.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :encrypted_password, :string

    field :password_reset_token, :string
    field :password_reset_sent_at, :naive_datetime

    timestamps()
  end

  @allowed_attrs [
    :email,
    :username,
    :encrypted_password,
    :password_reset_token,
    :password_reset_sent_at
  ]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @allowed_attrs)
    |> validate_required([:email, :username, :encrypted_password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:encrypted_password)
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end
end
