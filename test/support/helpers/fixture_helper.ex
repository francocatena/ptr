defmodule Ptr.Support.FixtureHelper do
  alias Ptr.Accounts.{Account, Session}
  alias Ptr.{Accounts, Repo, Ownerships}

  def fixture(type, attributes \\ %{}, opts \\ [])

  @user_attrs %{email: "some@email.com", lastname: "some lastname", name: "some name", password: "123456", password_confirmation: "123456"}

  def fixture(:user, attributes, %{account: account} = session) when is_map(session) do
    attributes  = Enum.into(attributes, @user_attrs)
    {:ok, user} = Accounts.create_user(session, attributes)

    {:ok, %{user | password: nil}, account}
  end

  def fixture(:user, attributes, _) do
    account = fixture(:seed_account)
    session = %Session{account: account}

    fixture(:user, attributes, session)
  end

  @account_attrs %{name: "fixture name", db_prefix: "fixture_prefix"}

  def fixture(:account, attributes, opts) do
    {:ok, account} =
      attributes
      |> Enum.into(@account_attrs)
      |> Accounts.create_account(opts)

    account
  end

  def fixture(:seed_account, _, _) do
    Repo.get_by!(Account, db_prefix: "test_account")
  end

  @owner_attrs %{name: "some name", tax_id: "some tax_id"}

  def fixture(:owner, attributes, _opts) do
    account      = fixture(:seed_account)
    session      = %Session{account: account}
    attributes   = Enum.into(attributes, @owner_attrs)
    {:ok, owner} = Ownerships.create_owner(session, attributes)

    {:ok, owner, account}
  end
end
