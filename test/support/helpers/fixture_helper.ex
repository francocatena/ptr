defmodule Ptr.Support.FixtureHelper do
  alias Ptr.Accounts.{Account, Session}
  alias Ptr.{Accounts, Cellars, Repo, Ownerships}

  def fixture(type, attributes \\ %{}, opts \\ [])

  @user_attrs %{
    email: "some@email.com",
    lastname: "some lastname",
    name: "some name",
    password: "123456",
    password_confirmation: "123456"
  }

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

  @cellar_attrs %{identifier: "some identifier", name: "some name"}

  def fixture(:cellar, attributes, _opts) do
    account       = fixture(:seed_account)
    session       = %Session{account: account}
    attributes    = Enum.into(attributes, @cellar_attrs)
    {:ok, cellar} = Cellars.create_cellar(session, attributes)

    {:ok, cellar, account}
  end

  @vessel_attrs %{
    capacity: "120.5000",
    cooling: "some cooling",
    identifier: "some identifier",
    material: "some material",
    notes: "some notes"
  }

  def fixture(:vessel, attributes, _opts) do
    account          = fixture(:seed_account)
    session          = %Session{account: account}
    {:ok, cellar, _} = fixture(:cellar, %{})

    create_vessel(session, cellar, attributes)
  end

  defp create_vessel(session, cellar, attributes) do
    attributes =
      attributes
      |> Enum.into(@vessel_attrs)
      |> Map.put(:cellar_id, cellar.id)

    {:ok, vessel} = Cellars.create_vessel(session, attributes)

    {:ok, vessel, cellar, session.account}
  end
end
