defmodule Ptr.Options.MaterialRepoTest do
  use Ptr.DataCase

  describe "material" do
    alias Ptr.Options.Material

    @valid_attrs %{name: "some name"}

    test "converts unique constraint on name to error" do
      {:ok, material, account} = fixture(:material, @valid_attrs)
      attrs = Map.put(@valid_attrs, :name, material.name)
      changeset = Material.changeset(account, %Material{}, attrs)
      prefix = Ptr.Accounts.prefix(account)
      {:error, changeset} = Repo.insert(changeset, prefix: prefix)

      expected = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:name]]
      }

      assert expected == changeset.errors[:name]
    end
  end
end
