defmodule Ptr.Accounts.Account do
  use Ecto.Schema

  import Ecto.Changeset
  import Mix.Ecto, only: [migrations_path: 1]

  alias Ecto.Adapters.{Postgres, SQL}
  alias Ptr.Repo
  alias Ptr.Accounts.{Account, User}


  schema "accounts" do
    field :db_prefix, :string
    field :name, :string
    field :lock_version, :integer, default: 1

    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :lock_version])
    |> validation
  end

  @doc false
  def create_changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :db_prefix, :lock_version])
    |> validation
  end

  @doc false
  def after_create({:ok, account}) do
    account
    |> create_schema
    |> migrate

    {:ok, account}
  end

  @doc false
  def after_create(error), do: error

  @doc false
  def after_delete({:ok, account}) do
    drop_schema(account)

    {:ok, account}
  end

  @doc false
  def after_delete(error), do: error

  defp validation(changeset) do
    changeset
    |> validate_required([:name, :db_prefix])
    |> validate_length(:name, max: 255)
    |> validate_length(:db_prefix, max: 61)
    |> validate_format(:db_prefix, ~r/^[a-z_][a-z0-9_]*$/)
    |> unique_constraint(:db_prefix)
    |> optimistic_lock(:lock_version)
  end

  defp create_schema(account) do
    prefix = build_prefix(account)

    case Repo.__adapter__ do
      Postgres -> SQL.query(Repo, "CREATE SCHEMA \"#{prefix}\"")
    end

    account
  end

  defp drop_schema(account) do
    prefix = build_prefix(account)

    case Repo.__adapter__ do
      Postgres -> SQL.query(Repo, "DROP SCHEMA \"#{prefix}\" CASCADE")
    end

    account
  end

  defp migrate(account) do
    prefix = build_prefix(account)
    opts   = [all: true, prefix: prefix]
    path   = migrations_path(Repo)

    handle_database_exceptions fn ->
      Ecto.Migrator.run(Repo, path, :up, opts)
    end
  end

  defp build_prefix(account) do
    "t_#{account.db_prefix}"
  end

  defp handle_database_exceptions(fun) do
    try do
      {:ok, fun.()}
    rescue
      e in Postgrex.Error ->
        {:error, Postgrex.Error.message(e)}
    end
  end
end
