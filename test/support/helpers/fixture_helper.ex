defmodule Ptr.Support.FixtureHelper do
  alias Ptr.{Accounts, Ownerships}

  def fixture(type, attributes \\ %{}, opts \\ [])

  @user_attrs %{email: "some@email.com", lastname: "some lastname", name: "some name", password: "123456", password_confirmation: "123456"}

  def fixture(:user, attributes, account) when is_map(account) do
    {:ok, user} =
      attributes
      |> Enum.into(@user_attrs)
      |> Accounts.create_user(account)

    {:ok, %{user | password: nil}, account}
  end

  def fixture(:user, attributes, _) do
    account = fixture(:account)

    fixture(:user, attributes, account)
  end

  @account_attrs %{name: "fixture name", db_prefix: "fixture_prefix"}

  def fixture(:account, attributes, opts) do
    {:ok, account} =
      attributes
      |> Enum.into(@account_attrs)
      |> Accounts.create_account(opts)

    account
  end

  @owner_attrs %{name: "some name", tax_id: "some tax_id"}

  def fixture(:owner, attributes, opts) do
    account = opts[:account] || fixture(:account, %{}, create_schema: true)

    {:ok, owner} =
      attributes
      |> Enum.into(@owner_attrs)
      |> Ownerships.create_owner(account)

    {:ok, owner, account}
  end
end
