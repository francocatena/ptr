defmodule Ptr.Support.FixtureHelper do
  alias Ptr.Accounts

  def fixture(type, attributes \\ %{}, opts \\ [])

  @user_attrs %{email: "some@email.com", lastname: "some lastname", name: "some name", password: "123456"}

  def fixture(:user, attributes, account_id) when is_integer(account_id) do
    {:ok, user} =
      attributes
      |> Enum.into(@user_attrs)
      |> Accounts.create_user(account_id)

    %{user | password: nil}
  end

  def fixture(:user, attributes, _) do
    account = fixture(:account)

    fixture(:user, attributes, account.id)
  end

  @account_attrs %{name: "fixture name", db_prefix: "fixture_prefix"}

  def fixture(:account, attributes, opts) do
    {:ok, account} =
      attributes
      |> Enum.into(@account_attrs)
      |> Accounts.create_account(opts)

    account
  end
end
