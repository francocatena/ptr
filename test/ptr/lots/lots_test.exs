defmodule Ptr.LotsTest do
  use Ptr.DataCase

  alias Ptr.Lots
  alias Ptr.Accounts.Session

  describe "lots" do
    alias Ptr.Lots.Lot

    @valid_attrs %{
      identifier: "some identifier",
      notes: "some notes",
      cellar_id: 1,
      owner_id: 1,
      variety_id: 1
    }
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

      {:ok, cellar, _} = fixture(:cellar)
      {:ok, owner, _} = fixture(:owner)
      {:ok, variety, _} = fixture(:variety)

      attrs = %{@valid_attrs | cellar_id: cellar.id, owner_id: owner.id, variety_id: variety.id}

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

  describe "parts" do
    alias Ptr.Lots.Part

    @valid_attrs %{amount: "120.5", amount_unit: "L", lot_id: "1", vessel_id: "1"}
    @update_attrs %{amount: "111.2", amount_unit: "L"}
    @invalid_attrs %{amount: nil, amount_unit: nil}

    test "list_parts/3 returns all parts" do
      {:ok, part, account} = fixture(:part)

      parts =
        account
        |> Lots.list_parts(part.lot, %{})
        |> Enum.map(&canonize_part/1)

      assert parts == [canonize_part(part)]
    end

    test "get_part!/3 returns the part with given id" do
      {:ok, part, account} = fixture(:part)

      assert canonize_part(Lots.get_part!(account, part.lot, part.id)) == canonize_part(part)
    end

    test "create_part/2 with valid data creates a part" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      {:ok, lot, _} = fixture(:lot)
      {:ok, vessel, _cellar, _} = fixture(:vessel)

      attrs = %{@valid_attrs | lot_id: lot.id, vessel_id: vessel.id}

      assert {:ok, %Part{} = part} = Lots.create_part(session, attrs)
      assert part.amount == Decimal.new("120.5")
      assert part.amount_unit == "L"
    end

    test "create_part/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lots.create_part(%Session{}, @invalid_attrs)
    end

    test "update_part/3 with valid data updates the part" do
      {:ok, part, account} = fixture(:part)
      session = %Session{account: account}

      assert {:ok, part} = Lots.update_part(session, part, @update_attrs)
      assert %Part{} = part
      assert part.amount == Decimal.new("111.2")
      assert part.amount_unit == "L"
    end

    test "update_part/3 with invalid data returns error changeset" do
      {:ok, part, account} = fixture(:part)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} = Lots.update_part(session, part, @invalid_attrs)
      assert canonize_part(part) == canonize_part(Lots.get_part!(account, part.lot, part.id))
    end

    test "delete_part/2 deletes the part" do
      {:ok, part, account} = fixture(:part)
      session = %Session{account: account}

      assert {:ok, %Part{}} = Lots.delete_part(session, part)
      assert_raise Ecto.NoResultsError, fn -> Lots.get_part!(account, part.lot, part.id) end
    end

    test "change_part/2 returns a part changeset" do
      {:ok, part, account} = fixture(:part)

      assert %Ecto.Changeset{} = Lots.change_part(account, part)
    end
  end

  defp canonize_part(%Ptr.Lots.Part{} = part) do
    %{part | lot: nil, vessel: nil}
  end
end
