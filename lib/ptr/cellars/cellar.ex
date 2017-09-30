defmodule Ptr.Cellars.Cellar do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Cellars.Cellar
  alias Ptr.Accounts.Account


  schema "cellars" do
    field :identifier, :string
    field :name, :string
    field :lock_version, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Cellar{} = cellar, attrs) do
    cellar
    |> cast(attrs, [:identifier, :name, :lock_version])
    |> validate_required([:identifier, :name])
    |> validate_length(:identifier, max: 255)
    |> validate_length(:name, max: 255)
    |> unsafe_validate_unique(:identifier, Ptr.Repo, prefix: prefix(account))
    |> unique_constraint(:identifier)
    |> optimistic_lock(:lock_version)
  end
end
