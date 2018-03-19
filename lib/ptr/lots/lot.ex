defmodule Ptr.Lots.Lot do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Lots.{Lot, Part}
  alias Ptr.Accounts.Account
  alias Ptr.Cellars.Cellar
  alias Ptr.Options.Variety
  alias Ptr.Ownerships.Owner

  schema "lots" do
    field(:identifier, :string)
    field(:notes, :string)
    field(:lock_version, :integer, default: 1)

    field(:parts_count, :integer, virtual: true, default: 0)

    belongs_to(:cellar, Cellar)
    belongs_to(:owner, Owner)
    belongs_to(:variety, Variety)

    has_many(:parts, Part)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Lot{} = lot, attrs) do
    lot
    |> cast(attrs, [:identifier, :notes, :cellar_id, :owner_id, :variety_id, :lock_version])
    |> validate_required([:identifier, :cellar_id, :owner_id, :variety_id])
    |> validate_length(:identifier, max: 255)
    |> unsafe_validate_unique(:identifier, Ptr.Repo, prefix: prefix(account))
    |> unique_constraint(:identifier)
    |> assoc_constraint(:cellar)
    |> assoc_constraint(:owner)
    |> assoc_constraint(:variety)
    |> optimistic_lock(:lock_version)
  end
end
