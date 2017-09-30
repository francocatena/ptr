defmodule Ptr.Ownerships.OwnerRepoTest do
  use Ptr.DataCase

  describe "owner" do
    alias Ptr.Ownerships.Owner

    @valid_attrs %{name: "some name", tax_id: "123456"}

    test "converts unique constraint on tax id to error" do
      {:ok, owner, account} = fixture(:owner, @valid_attrs)
      attrs                 = Map.put(@valid_attrs, :tax_id, owner.tax_id)
      changeset             = Owner.changeset(account, %Owner{}, attrs)
      prefix                = Ptr.Accounts.prefix(account)
      {:error, changeset}   = Repo.insert(changeset, prefix: prefix)
      expected              = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:tax_id]]
      }

      assert expected == changeset.errors[:tax_id]
    end
  end
end
