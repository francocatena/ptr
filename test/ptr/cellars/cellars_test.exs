defmodule Ptr.CellarsTest do
  use Ptr.DataCase

  alias Ptr.Cellars
  alias Ptr.Accounts.Session

  describe "cellars" do
    alias Ptr.Cellars.Cellar

    @valid_attrs %{identifier: "some identifier", name: "some name"}
    @update_attrs %{identifier: "some updated identifier", name: "some updated name"}
    @invalid_attrs %{identifier: nil, name: nil}

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

    test "change_cellar/1 returns a cellar changeset" do
      {:ok, cellar, _} = fixture(:cellar)

      assert %Ecto.Changeset{} = Cellars.change_cellar(cellar)
    end
  end
end
