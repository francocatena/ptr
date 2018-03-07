defmodule Ptr.LotsTest do
  use Ptr.DataCase

  alias Ptr.Lots
  alias Ptr.Accounts.Session

  describe "lots" do
    alias Ptr.Lots.Lot

    @valid_attrs %{identifier: "some identifier", notes: "some notes", owner_id: 1, variety_id: 1}
    @update_attrs %{identifier: "some updated identifier", notes: "some updated notes"}
    @invalid_attrs %{identifier: nil, notes: nil}

    test "list_lots/2 returns all lots" do
      {:ok, lot, account} = fixture(:lot)

      assert Lots.list_lots(account, %{}).entries == [lot]
    end

    test "get_lot!/2 returns the lot with given id" do
      {:ok, lot, account} = fixture(:lot)

      assert Lots.get_lot!(account, lot.id) == lot
    end

    test "create_lot/2 with valid data creates a lot" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      {:ok, owner, _} = fixture(:owner)
      {:ok, variety, _} = fixture(:variety)

      attrs = %{@valid_attrs | owner_id: owner.id, variety_id: variety.id}

      assert {:ok, %Lot{} = lot} = Lots.create_lot(session, attrs)
      assert lot.identifier == "some identifier"
      assert lot.notes == "some notes"
    end

    test "create_lot/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lots.create_lot(%Session{}, @invalid_attrs)
    end

    test "update_lot/3 with valid data updates the lot" do
      {:ok, lot, account} = fixture(:lot)
      session = %Session{account: account}

      assert {:ok, lot} = Lots.update_lot(session, lot, @update_attrs)
      assert %Lot{} = lot
      assert lot.identifier == "some updated identifier"
      assert lot.notes == "some updated notes"
    end

    test "update_lot/3 with invalid data returns error changeset" do
      {:ok, lot, account} = fixture(:lot)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} = Lots.update_lot(session, lot, @invalid_attrs)
      assert lot == Lots.get_lot!(account, lot.id)
    end

    test "delete_lot/2 deletes the lot" do
      {:ok, lot, account} = fixture(:lot)
      session = %Session{account: account}

      assert {:ok, %Lot{}} = Lots.delete_lot(session, lot)
      assert_raise Ecto.NoResultsError, fn -> Lots.get_lot!(account, lot.id) end
    end

    test "change_lot/2 returns a lot changeset" do
      {:ok, lot, account} = fixture(:lot)

      assert %Ecto.Changeset{} = Lots.change_lot(account, lot)
    end
  end
end
