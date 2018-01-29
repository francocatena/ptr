defmodule Ptr.Options.VarietyRepoTest do
  use Ptr.DataCase

  describe "variety" do
    alias Ptr.Options.Variety

    @valid_attrs %{identifier: "some identifier", name: "some name", clone: "some clone"}

    test "converts unique constraint on identifier to error" do
      {:ok, variety, account} = fixture(:variety, @valid_attrs)
      attrs = Map.put(@valid_attrs, :identifier, variety.identifier)
      changeset = Variety.changeset(account, %Variety{}, attrs)
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
