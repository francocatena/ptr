defmodule Ptr.Cellars.CellarRepoTest do
  use Ptr.DataCase

  describe "cellar" do
    alias Ptr.Cellars.Cellar

    @valid_attrs %{identifier: "some identifier", name: "some name"}

    test "converts unique constraint on identifier to error" do
      {:ok, cellar, account} = fixture(:cellar, @valid_attrs)
      attrs = Map.put(@valid_attrs, :identifier, cellar.identifier)
      changeset = Cellar.changeset(account, %Cellar{}, attrs)
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
