defmodule Ptr.Ownerships.Owner do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Ownerships.Owner
  alias Ptr.Accounts.Account

  schema "owners" do
    field(:name, :string)
    field(:tax_id, :string)
    field(:lock_version, :integer, default: 1)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Owner{} = owner, attrs) do
    owner
    |> cast(attrs, [:name, :tax_id, :lock_version])
    |> validate_required([:name, :tax_id])
    |> validate_length(:name, max: 255)
    |> validate_length(:tax_id, max: 255)
    |> unsafe_validate_unique(:tax_id, Ptr.Repo, prefix: prefix(account))
    |> unique_constraint(:tax_id)
    |> optimistic_lock(:lock_version)
  end
end
