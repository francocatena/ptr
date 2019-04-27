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

    test "list_varieties/1 returns all varieties" do
      {:ok, variety, account} = fixture(:variety)

      assert Options.list_varieties(account) == [variety]
    end

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

  describe "materials" do
    alias Ptr.Options.Material

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_materials/1 returns all materials" do
      {:ok, material, account} = fixture(:material)

      assert Options.list_materials(account) == [material]
    end

    test "list_materials/2 returns all materials" do
      {:ok, material, account} = fixture(:material)

      assert Options.list_materials(account, %{}).entries == [material]
    end

    test "get_material!/2 returns the material with given id" do
      {:ok, material, account} = fixture(:material)

      assert Options.get_material!(account, material.id) == material
    end

    test "create_material/2 with valid data creates a material" do
      account = fixture(:seed_account)
      session = %Session{account: account}

      assert {:ok, %Material{} = material} = Options.create_material(session, @valid_attrs)
      assert material.name == "some name"
    end

    test "create_material/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Options.create_material(%Session{}, @invalid_attrs)
    end

    test "update_material/3 with valid data updates the material" do
      {:ok, material, account} = fixture(:material)
      session = %Session{account: account}

      assert {:ok, material} = Options.update_material(session, material, @update_attrs)
      assert %Material{} = material
      assert material.name == "some updated name"
    end

    test "update_material/3 with invalid data returns error changeset" do
      {:ok, material, account} = fixture(:material)
      session = %Session{account: account}

      assert {:error, %Ecto.Changeset{}} =
               Options.update_material(session, material, @invalid_attrs)

      assert material == Options.get_material!(account, material.id)
    end

    test "delete_material/2 deletes the material" do
      {:ok, material, account} = fixture(:material)
      session = %Session{account: account}

      assert {:ok, %Material{}} = Options.delete_material(session, material)
      assert_raise Ecto.NoResultsError, fn -> Options.get_material!(account, material.id) end
    end

    test "change_material/2 returns a material changeset" do
      {:ok, material, account} = fixture(:material)

      assert %Ecto.Changeset{} = Options.change_material(account, material)
    end
  end
end
