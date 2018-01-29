defmodule Ptr.OptionsTest do
  use Ptr.DataCase

  alias Ptr.Options
  alias Ptr.Accounts.Session

  describe "varieties" do
    alias Ptr.Options.Variety

    @valid_attrs %{clone: "some clone", identifier: "some identifier", name: "some name"}
    @update_attrs %{
      clone: "some updated clone",
      identifier: "some updated identifier",
      name: "some updated name"
    }
    @invalid_attrs %{clone: nil, identifier: nil, name: nil}

    test "list_varieties/2 returns all varieties" do
      {:ok, variety, account} = fixture(:variety)

      assert Options.list_varieties(account, %{}).entries == [variety]
    end

    test "get_variety!/2 returns the variety with given id" do
      {:ok, variety, account} = fixture(:variety)

      assert Options.get_variety!(account, variety.id) == variety
    end

    test "create_variety/2 with valid data creates a variety" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      assert {:ok, %Variety{} = variety} = Options.create_variety(session, @valid_attrs)
      assert variety.clone == "some clone"
      assert variety.identifier == "some identifier"
      assert variety.name == "some name"
    end

    test "create_variety/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Options.create_variety(%Session{}, @invalid_attrs)
    end

    test "update_variety/3 with valid data updates the variety" do
      {:ok, variety, account} = fixture(:variety)
      session = %Session{account: account}

      assert {:ok, variety} = Options.update_variety(session, variety, @update_attrs)
      assert %Variety{} = variety
      assert variety.clone == "some updated clone"
      assert variety.identifier == "some updated identifier"
      assert variety.name == "some updated name"
    end

    test "update_variety/3 with invalid data returns error changeset" do
      {:ok, variety, account} = fixture(:variety)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} =
               Options.update_variety(session, variety, @invalid_attrs)

      assert variety == Options.get_variety!(account, variety.id)
    end

    test "delete_variety/2 deletes the variety" do
      {:ok, variety, account} = fixture(:variety)
      session = %Session{account: account}

      assert {:ok, %Variety{}} = Options.delete_variety(session, variety)
      assert_raise Ecto.NoResultsError, fn -> Options.get_variety!(account, variety.id) end
    end

    test "change_variety/2 returns a variety changeset" do
      {:ok, variety, account} = fixture(:variety)

      assert %Ecto.Changeset{} = Options.change_variety(account, variety)
    end
  end
end
