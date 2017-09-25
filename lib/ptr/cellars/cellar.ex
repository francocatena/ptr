defmodule Ptr.Cellars.Cellar do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ptr.Cellars.Cellar


  schema "cellars" do
    field :identifier, :string
    field :name, :string
    field :lock_version, :integer, default: 1

    timestamps()
  end

  # TODO: add unsafe_validate_unique when prefix support
  @doc false
  def changeset(%Cellar{} = cellar, attrs) do
    cellar
    |> cast(attrs, [:identifier, :name, :lock_version])
    |> validate_required([:identifier, :name])
    |> validate_length(:identifier, max: 255)
    |> validate_length(:name, max: 255)
    |> unique_constraint(:identifier)
    |> optimistic_lock(:lock_version)
  end
end
