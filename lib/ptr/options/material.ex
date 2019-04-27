defmodule Ptr.Options.Material do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Options.Material
  alias Ptr.Cellars.Vessel
  alias Ptr.Accounts.Account

  schema "materials" do
    field(:name, :string)
    field(:lock_version, :integer, default: 1)

    field(:vessels_count, :integer, virtual: true, default: 0)

    has_many(:vessels, Vessel)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Material{} = material, attrs) do
    material
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 255)
    |> unsafe_validate_unique(:name, Ptr.Repo, prefix: prefix(account))
    |> unique_constraint(:name)
    |> optimistic_lock(:lock_version)
  end
end
