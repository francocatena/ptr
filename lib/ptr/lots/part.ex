defmodule Ptr.Lots.Part do
  use Ecto.Schema

  import Ecto.Changeset

  alias Ptr.Lots.{Lot, Part}
  alias Ptr.Accounts.Account
  alias Ptr.Cellars.Vessel

  schema "parts" do
    field(:amount, :decimal)
    field(:amount_unit, :string, default: "L")
    field(:lock_version, :integer, default: 1)

    belongs_to(:lot, Lot)
    belongs_to(:vessel, Vessel)

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, %Part{} = part, attrs) do
    part
    |> cast(attrs, [:amount, :amount_unit, :lot_id, :vessel_id, :lock_version])
    |> validate_required([:amount, :amount_unit, :lot_id, :vessel_id])
    |> validate_length(:amount_unit, max: 255)
    |> validate_number(:amount, greater_than_or_equal_to: 0, less_than_or_equal_to: 99_999_999.99)
    |> validate_inclusion(:amount_unit, ["L"])
    |> assoc_constraint(:lot)
    |> assoc_constraint(:vessel)
    |> check_if_fits_in_vessel(:amount, account)
    |> optimistic_lock(:lock_version)
  end

  defp check_if_fits_in_vessel(
         %{data: %{id: nil}, changes: %{amount: _amount, vessel_id: vessel_id}} = changeset,
         field,
         %Account{} = account
       ) do
    check_if_fits_in_vessel(changeset, account, field, vessel_id)
  end

  defp check_if_fits_in_vessel(
         %{data: %{id: _id}, changes: %{amount: _amount, vessel_id: vessel_id}} = changeset,
         field,
         %Account{} = account
       ) do
    check_if_fits_in_vessel(changeset, account, field, vessel_id)
  end

  defp check_if_fits_in_vessel(
         %{data: %{id: id, amount: old_amount, vessel_id: vessel_id}, changes: %{amount: _amount}} =
           changeset,
         field,
         %Account{} = account
       )
       when not is_nil(id) do
    check_if_fits_in_vessel(changeset, account, field, vessel_id, old_amount)
  end

  defp check_if_fits_in_vessel(
         %{data: %{id: id}, changes: %{vessel_id: vessel_id}} = changeset,
         field,
         %Account{} = account
       )
       when not is_nil(id) do
    check_if_fits_in_vessel(changeset, account, field, vessel_id)
  end

  defp check_if_fits_in_vessel(changeset, _field, %Account{} = _account) do
    changeset
  end

  defp check_if_fits_in_vessel(changeset, %Account{} = account, field, vessel_id, old_amount \\ 0) do
    validate_change(changeset, field, fn _, amount ->
      vessel = Ptr.Cellars.get_vessel!(account, vessel_id)
      remainig = Decimal.add(Decimal.sub(vessel.capacity, vessel.usage), old_amount)

      if Decimal.cmp(amount, remainig) == :gt do
        number = Decimal.to_string(Decimal.round(remainig))

        [{field, {"must be less than or equal to %{number}", number: number}}]
      else
        []
      end
    end)
  end
end
