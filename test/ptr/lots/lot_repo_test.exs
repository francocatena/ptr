defmodule Ptr.Lots.LotRepoTest do
  use Ptr.DataCase

  describe "lot" do
    alias Ptr.Lots.Lot

    @valid_attrs %{identifier: "some identifier", notes: "some notes"}

    test "converts unique constraint on identifier to error" do
      {:ok, lot, account} = fixture(:lot, @valid_attrs)
      attrs = Map.put(@valid_attrs, :identifier, lot.identifier)
      changeset = Lot.changeset(account, %Lot{}, attrs)
      prefix = Ptr.Accounts.prefix(account)
      {:error, changeset} = Repo.insert(changeset, prefix: prefix)

      expected = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:identifier]]
      }

      assert expected == changeset.errors[:identifier]
    end
  end
end
