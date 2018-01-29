defmodule Ptr.Options.Variety do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Options.Variety
  alias Ptr.Accounts.Account

  schema "varieties" do
    field(:clone, :string)
    field(:identifier, :string)
    field(:name, :string)
    field(:lock_version, :integer, default: 1)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Variety{} = variety, attrs) do
    variety
    |> cast(attrs, [:identifier, :name, :clone, :lock_version])
    |> validate_required([:identifier, :name, :clone])
    |> validate_length(:identifier, max: 255)
    |> validate_length(:name, max: 255)
    |> validate_length(:clone, max: 255)
    |> unsafe_validate_unique(:identifier, Ptr.Repo, prefix: prefix(account))
    |> unique_constraint(:identifier)
    |> optimistic_lock(:lock_version)
  end
end
