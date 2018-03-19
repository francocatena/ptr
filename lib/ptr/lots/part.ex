defmodule Ptr.Lots.Part do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ptr.Lots.{Lot, Part}
  alias Ptr.Accounts.Account
  alias Ptr.Cellars.Vessel

  schema "parts" do
    field(:amount, :decimal)
    field(:amount_unit, :string, default: "l")
    field(:lock_version, :integer, default: 1)

    belongs_to(:lot, Lot)
    belongs_to(:vessel, Vessel)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = _account, %Part{} = part, attrs) do
    part
    |> cast(attrs, [:amount, :amount_unit, :lot_id, :vessel_id, :lock_version])
    |> validate_required([:amount, :amount_unit, :lot_id, :vessel_id])
    |> validate_length(:amount_unit, max: 255)
    |> validate_number(:amount, greater_than_or_equal_to: 0, less_than_or_equal_to: 99_999_999.99)
    |> validate_inclusion(:amount_unit, ["l"])
    |> assoc_constraint(:lot)
    |> assoc_constraint(:vessel)
    |> optimistic_lock(:lock_version)
  end
end
