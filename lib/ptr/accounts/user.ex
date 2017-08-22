defmodule Ptr.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ptr.Accounts.{Account, User}
  alias Ptr.Repo


  schema "users" do
    field :email, :string
    field :lastname, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :lastname, :email, :password])
    |> validation
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :lastname, :email, :password])
    |> validate_required([:password, :account_id])
    |> validation
  end

  defp validation(changeset) do
    changeset
    |> validate_required([:name, :lastname, :email])
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> validate_length(:name, max: 255)
    |> validate_length(:lastname, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_length(:password, min: 6, max: 100)
    |> unsafe_validate_unique(:email, Repo)
    |> unique_constraint(:email)
    |> assoc_constraint(:account)
    |> put_password_hash()
  end

  defp put_password_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
