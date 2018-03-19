defmodule Ptr.Lots.PartTest do
  use Ptr.DataCase, async: true

  describe "part" do
    alias Ptr.Lots.Part

    @valid_attrs %{amount: "100.0", lot_id: 1, vessel_id: 1}
    @invalid_attrs %{amount: nil, amount_unit: "x"}

    test "changeset with valid attributes" do
      changeset = test_account() |> Part.changeset(%Part{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Part.changeset(%Part{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs = Map.put(@valid_attrs, :amount_unit, String.duplicate("a", 256))

      changeset = test_account() |> Part.changeset(%Part{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).amount_unit
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
