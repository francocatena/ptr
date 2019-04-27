defmodule Ptr.CellarsTest do
  use Ptr.DataCase

  alias Ptr.Cellars
  alias Ptr.Accounts.Session

  describe "cellars" do
    alias Ptr.Cellars.Cellar

    @valid_attrs %{identifier: "some identifier", name: "some name"}
    @update_attrs %{identifier: "some updated identifier", name: "some updated name"}
    @invalid_attrs %{identifier: nil, name: nil}

    test "list_cellars/1 returns all cellars" do
      {:ok, cellar, account} = fixture(:cellar)

      assert Cellars.list_cellars(account) == [cellar]
    end

    test "list_cellars/2 returns all cellars" do
      {:ok, cellar, account} = fixture(:cellar)

      assert Cellars.list_cellars(account, %{}).entries == [cellar]
    end

    test "get_cellar!/2 returns the cellar with given id" do
      {:ok, cellar, account} = fixture(:cellar)

      assert Cellars.get_cellar!(account, cellar.id) == cellar
    end

    test "create_cellar/2 with valid data creates a cellar" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      assert {:ok, %Cellar{} = cellar} = Cellars.create_cellar(session, @valid_attrs)
      assert cellar.identifier == "some identifier"
      assert cellar.name == "some name"
    end

    test "create_cellar/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cellars.create_cellar(%Session{}, @invalid_attrs)
    end

    test "update_cellar/3 with valid data updates the cellar" do
      {:ok, cellar, account} = fixture(:cellar)
      session = %Session{account: account}

      assert {:ok, cellar} = Cellars.update_cellar(session, cellar, @update_attrs)
      assert %Cellar{} = cellar
      assert cellar.identifier == "some updated identifier"
      assert cellar.name == "some updated name"
    end

    test "update_cellar/3 with invalid data returns error changeset" do
      {:ok, cellar, account} = fixture(:cellar)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} = Cellars.update_cellar(session, cellar, @invalid_attrs)
      assert cellar == Cellars.get_cellar!(account, cellar.id)
    end

    test "delete_cellar/2 deletes the cellar" do
      {:ok, cellar, account} = fixture(:cellar)
      session = %Session{account: account}

      assert {:ok, %Cellar{}} = Cellars.delete_cellar(session, cellar)
      assert_raise Ecto.NoResultsError, fn -> Cellars.get_cellar!(account, cellar.id) end
    end

    test "change_cellar/2 returns a cellar changeset" do
      {:ok, cellar, account} = fixture(:cellar)

      assert %Ecto.Changeset{} = Cellars.change_cellar(account, cellar)
    end
  end

  describe "vessels" do
    alias Ptr.Cellars.Vessel

    @valid_attrs %{
      capacity: "120.5",
      cooling: "some cooling",
      identifier: "some identifier",
      notes: "some notes",
      cellar_id: "1",
      material_id: "1"
    }

    @update_attrs %{
      capacity: "456.7",
      cooling: "some updated cooling",
      identifier: "some updated identifier",
      notes: "some updated notes"
    }

    @invalid_attrs %{
      capacity: nil,
      cooling: nil,
      identifier: nil,
      notes: nil,
      cellar_id: nil,
      material_id: nil
    }

    test "list_vessels/2 returns all vessels for a given cellar" do
      {:ok, vessel, account} = fixture(:vessel)

      vessel_ids =
        account
        |> Cellars.list_vessels(vessel.cellar)
        |> Enum.map(& &1.id)

      assert vessel_ids == [vessel.id]
    end

    test "list_vessels/3 returns all vessels for a given cellar" do
      {:ok, vessel, account} = fixture(:vessel)
      entries = Cellars.list_vessels(account, vessel.cellar, %{}).entries
      vessel_ids = Enum.map(entries, & &1.id)

      assert vessel_ids == [vessel.id]
    end

    test "get_vessel!/2 returns the vessel with given id" do
      {:ok, vessel, account} = fixture(:vessel)
      retrieved_vessel = Cellars.get_vessel!(account, vessel.id)

      assert retrieved_vessel.id == vessel.id
      assert retrieved_vessel.cellar_id == vessel.cellar_id
    end

    test "get_vessel!/3 returns the vessel with given id form the given cellar" do
      {:ok, vessel, account} = fixture(:vessel)
      retrieved_vessel = Cellars.get_vessel!(account, vessel.cellar, vessel.id)

      assert retrieved_vessel.id == vessel.id
      assert retrieved_vessel.cellar_id == vessel.cellar_id
    end

    test "create_vessel/2 with valid data creates a vessel" do
      account = fixture(:seed_account)
      {:ok, cellar, _} = fixture(:cellar)
      {:ok, material, _} = fixture(:material)
      session = %Session{account: account}
      attributes = %{@valid_attrs | cellar_id: cellar.id, material_id: material.id}

      assert {:ok, %Vessel{} = vessel} = Cellars.create_vessel(session, attributes)
      assert vessel.capacity == Decimal.new("120.5")
      assert vessel.cooling == "some cooling"
      assert vessel.identifier == "some identifier"
      assert vessel.notes == "some notes"
    end

    test "create_vessel/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cellars.create_vessel(%Session{}, @invalid_attrs)
    end

    test "update_vessel/3 with valid data updates the vessel" do
      {:ok, vessel, account} = fixture(:vessel)
      session = %Session{account: account}

      assert {:ok, vessel} = Cellars.update_vessel(session, vessel, @update_attrs)
      assert %Vessel{} = vessel
      assert vessel.capacity == Decimal.new("456.7")
      assert vessel.cooling == "some updated cooling"
      assert vessel.identifier == "some updated identifier"
      assert vessel.notes == "some updated notes"
    end

    test "update_vessel/3 with invalid data returns error changeset" do
      {:ok, vessel, account} = fixture(:vessel)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} = Cellars.update_vessel(session, vessel, @invalid_attrs)
    end

    test "delete_vessel/2 deletes the vessel" do
      {:ok, vessel, account} = fixture(:vessel)
      session = %Session{account: account}

      assert {:ok, %Vessel{}} = Cellars.delete_vessel(session, vessel)

      assert_raise Ecto.NoResultsError, fn ->
        Cellars.get_vessel!(account, vessel.cellar, vessel.id)
      end
    end

    test "change_vessel/2 returns a vessel changeset" do
      {:ok, vessel, account} = fixture(:vessel)

      assert %Ecto.Changeset{} = Cellars.change_vessel(account, vessel)
    end
  end
end
