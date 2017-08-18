defmodule Ptr.AccountsTest do
  use Ptr.DataCase

  alias Ptr.Accounts

  describe "accounts" do
    alias Ptr.Accounts.Account

    @valid_attrs   %{db_prefix: "db_prefix", name: "some name"}
    @update_attrs  %{db_prefix: "updated_db_prefix", name: "some updated name"}
    @invalid_attrs %{db_prefix: "db prefix", name: nil}

    test "list_accounts/0 returns all accounts" do
      account = fixture(:account, @valid_attrs)

      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = fixture(:account, @valid_attrs)

      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account without schema" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs, create_schema: false)
      assert account.db_prefix == "db_prefix"
      assert account.name == "some name"
      refute schema_exists?(account.db_prefix)
    end

    test "create_account/1 with valid data creates a account with schema" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.db_prefix == "db_prefix"
      assert account.name == "some name"
      assert schema_exists?(account.db_prefix)
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = fixture(:account, @valid_attrs)

      assert {:ok, account} = Accounts.update_account(account, @update_attrs)
      assert %Account{} = account
      assert account.db_prefix == "db_prefix" # Ignored on update
      assert account.name == "some updated name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = fixture(:account, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = fixture(:account, @valid_attrs)

      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = fixture(:account, @valid_attrs)

      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  describe "users" do
    alias Ptr.Accounts.User

    @valid_attrs   %{email: "some@email.com", lastname: "some lastname", name: "some name", password: "123456"}
    @update_attrs  %{email: "new@email.com", lastname: "some updated lastname", name: "some updated name"}
    @invalid_attrs %{email: "wrong@email", lastname: nil, name: nil, password: "123"}

    test "list_users/2 returns all users on the specified account" do
      user = fixture(:user)

      assert Accounts.list_users(user.account_id, %{}).entries == [user]
    end

    test "list_users/2 returns empty list for empty account" do
      account = fixture(:account, %{db_prefix: "accounts_user_test"})

      fixture(:user) # Unlisted user

      assert Accounts.list_users(account.id, %{}).entries == []
    end

    test "get_user!/2 returns the user with given id and account_id" do
      user = fixture(:user)

      assert Accounts.get_user!(user.id, user.account_id) == user
    end

    test "get_user!/2 returns no result when user id and account_id mismatch" do
      account = fixture(:account, %{db_prefix: "accounts_user_test"})
      user    = fixture(:user)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(user.id, account.id)
      end
    end

    test "create_user/2 with valid data creates a user" do
      account = fixture(:account)

      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs, account.id)
      assert user.email == "some@email.com"
      assert user.lastname == "some lastname"
      assert user.name == "some name"
    end

    test "create_user/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs, nil)
    end

    test "update_user/2 with valid data updates the user" do
      user = fixture(:user, @valid_attrs)

      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "new@email.com"
      assert user.lastname == "some updated lastname"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = fixture(:user)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id, user.account_id)
    end

    test "delete_user/1 deletes the user" do
      user = fixture(:user)

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(user.id, user.account_id)
      end
    end

    test "change_user/1 returns a user changeset" do
      user = fixture(:user)

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "auth" do
    test "authenticate_by_email_and_password/2 returns :ok with valid credentials" do
      user     = fixture(:user, @valid_attrs)
      email    = @valid_attrs.email
      password = @valid_attrs.password

      {:ok, auth_user} = Accounts.authenticate_by_email_and_password(email, password)

      assert auth_user == user
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid credentials" do
      email    = @valid_attrs.email
      password = "wrong"

      fixture(:user, @valid_attrs) # Create user just to be sure

      assert {:error, :unauthorized} ==
        Accounts.authenticate_by_email_and_password(email, password)
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid email" do
      email    = "invalid@email.com"
      password = @valid_attrs.password

      assert {:error, :unauthorized} ==
        Accounts.authenticate_by_email_and_password(email, password)
    end
  end

  defp schema_exists?(prefix) do
    query = "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 't_#{prefix}';"

    {:ok, %{num_rows: rows}} = Ecto.Adapters.SQL.query(Repo, query)

    rows == 1
  end
end
