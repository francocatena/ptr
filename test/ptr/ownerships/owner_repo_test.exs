defmodule Ptr.Ownerships.OwnerRepoTest do
  use Ptr.DataCase

  describe "owner" do
    alias Ptr.Ownerships.Owner

    @valid_attrs %{name: "some name", tax_id: "123456"}

    test "converts unique constraint on tax id to error" do
      {:ok, owner, account} = fixture(:owner, @valid_attrs)
      attrs                 = Map.put(@valid_attrs, :tax_id, owner.tax_id)
      changeset             = Owner.changeset(%Owner{}, attrs)
      prefix                = Ptr.Accounts.prefix(account)
      {:error, changeset}   = Repo.insert(changeset, prefix: prefix)

      assert "has already been taken" in errors_on(changeset).tax_id
    end
  end
end

