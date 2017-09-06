defmodule Ptr.OwnershipsTest do
  use Ptr.DataCase

  alias Ptr.Ownerships

  describe "owners" do
    alias Ptr.Ownerships.Owner

    @valid_attrs %{name: "some name", tax_id: "some tax_id"}
    @update_attrs %{name: "some updated name", tax_id: "some updated tax_id"}
    @invalid_attrs %{name: nil, tax_id: nil}

    test "list_owners/2 returns all owners" do
      {:ok, owner, account} = fixture(:owner)

      assert Ownerships.list_owners(account, %{}).entries == [owner]
    end

    test "get_owner!/2 returns the owner with given id" do
      {:ok, owner, account} = fixture(:owner)

      assert Ownerships.get_owner!(account, owner.id) == owner
    end

    test "create_owner/2 with valid data creates a owner" do
      account = fixture(:seed_account)

      assert {:ok, %Owner{} = owner} = Ownerships.create_owner(account, @valid_attrs)
      assert owner.name == "some name"
      assert owner.tax_id == "some tax_id"
    end

    test "create_owner/2 with invalid data returns error changeset" do
      account = fixture(:seed_account)

      assert {:error, %Ecto.Changeset{}} = Ownerships.create_owner(account, @invalid_attrs)
    end

    test "update_owner/3 with valid data updates the owner" do
      {:ok, owner, account} = fixture(:owner)

      assert {:ok, owner} = Ownerships.update_owner(account, owner, @update_attrs)
      assert %Owner{} = owner
      assert owner.name == "some updated name"
      assert owner.tax_id == "some updated tax_id"
    end

    test "update_owner/3 with invalid data returns error changeset" do
      {:ok, owner, account} = fixture(:owner)

      assert {:error, %Ecto.Changeset{}} = Ownerships.update_owner(account, owner, @invalid_attrs)
      assert owner == Ownerships.get_owner!(account, owner.id)
    end

    test "delete_owner/2 deletes the owner" do
      {:ok, owner, account} = fixture(:owner)

      assert {:ok, %Owner{}} = Ownerships.delete_owner(account, owner)
      assert_raise Ecto.NoResultsError, fn ->
        Ownerships.get_owner!(account, owner.id)
      end
    end

    test "change_owner/1 returns a owner changeset" do
      {:ok, owner, _} = fixture(:owner)

      assert %Ecto.Changeset{} = Ownerships.change_owner(owner)
    end
  end
end
