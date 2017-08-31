defmodule Ptr.Ownerships.Owner do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ptr.Ownerships.Owner


  schema "owners" do
    field :name, :string
    field :tax_id, :string
    field :lock_version, :integer, default: 1

    timestamps()
  end

  # TODO: add unsafe_validate_unique when prefix support
  @doc false
  def changeset(%Owner{} = owner, attrs) do
    owner
    |> cast(attrs, [:name, :tax_id, :lock_version])
    |> validate_required([:name, :tax_id])
    |> validate_length(:name, max: 255)
    |> validate_length(:tax_id, max: 255)
    |> unique_constraint(:tax_id)
    |> optimistic_lock(:lock_version)
  end
end
