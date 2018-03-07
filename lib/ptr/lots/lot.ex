defmodule Ptr.Lots.Lot do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Lots.Lot
  alias Ptr.Accounts.Account
  alias Ptr.Options.Variety
  alias Ptr.Ownerships.Owner

  schema "lots" do
    field(:identifier, :string)
    field(:notes, :string)
    field(:lock_version, :integer, default: 1)

    belongs_to(:owner, Owner)
    belongs_to(:variety, Variety)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Lot{} = lot, attrs) do
    lot
    |> cast(attrs, [:identifier, :notes, :owner_id, :variety_id, :lock_version])
    |> validate_required([:identifier, :owner_id, :variety_id])
    |> validate_length(:identifier, max: 255)
    |> unsafe_validate_unique(:identifier, Ptr.Repo, prefix: prefix(account))
    |> unique_constraint(:identifier)
    |> assoc_constraint(:owner)
    |> assoc_constraint(:variety)
    |> optimistic_lock(:lock_version)
  end
end
