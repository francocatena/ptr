defmodule Ptr.Lots.LotTest do
  use Ptr.DataCase, async: true

  describe "lot" do
    alias Ptr.Lots.Lot

    @valid_attrs %{identifier: "some identifier", notes: "some notes", owner_id: 1, variety_id: 1}
    @invalid_attrs %{identifier: nil, notes: nil}

    test "changeset with valid attributes" do
      changeset = test_account() |> Lot.changeset(%Lot{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Lot.changeset(%Lot{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs = Map.put(@valid_attrs, :identifier, String.duplicate("a", 256))

      changeset = test_account() |> Lot.changeset(%Lot{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).identifier
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
