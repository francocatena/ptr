defmodule Ptr.Lots.PartTest do
  use Ptr.DataCase

  describe "part" do
    alias Ptr.Lots.Part

    @valid_attrs %{amount: "100.0", lot_id: 1, vessel_id: 1}
    @invalid_attrs %{amount: nil, amount_unit: "x", vessel_id: nil}

    test "changeset with valid attributes" do
      {:ok, vessel, _cellar, _account} = fixture(:vessel)
      attrs = %{@valid_attrs | vessel_id: vessel.id}
      changeset = test_account() |> Part.changeset(%Part{}, attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      {:ok, vessel, _cellar, _account} = fixture(:vessel)
      attrs = %{@invalid_attrs | vessel_id: vessel.id}
      changeset = test_account() |> Part.changeset(%Part{}, attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      {:ok, vessel, _cellar, _account} = fixture(:vessel)
      attrs = %{@valid_attrs | vessel_id: vessel.id}
      attrs = Map.put(attrs, :amount_unit, String.duplicate("a", 256))

      changeset = test_account() |> Part.changeset(%Part{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).amount_unit
    end

    test "changeset does not accept amounts that overflows vessel" do
      {:ok, vessel, _cellar, _account} = fixture(:vessel)
      bad_amount = Decimal.add(Decimal.sub(vessel.capacity, vessel.usage), 1)
      attrs = %{@valid_attrs | vessel_id: vessel.id, amount: bad_amount}
      changeset = test_account() |> Part.changeset(%Part{}, attrs)

      refute changeset.valid?
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
