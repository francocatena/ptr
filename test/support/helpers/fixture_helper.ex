defmodule Ptr.Support.FixtureHelper do
  alias Ptr.Accounts.{Account, Session}
  alias Ptr.{Accounts, Cellars, Lots, Repo, Options, Ownerships}

  def fixture(type, attributes \\ %{}, opts \\ [])

  @user_attrs %{
    email: "some@email.com",
    lastname: "some lastname",
    name: "some name",
    password: "123456",
    password_confirmation: "123456"
  }

  def fixture(:user, attributes, %{account: account} = session) when is_map(session) do
    attributes = Enum.into(attributes, @user_attrs)
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
    account = fixture(:seed_account)
    session = %Session{account: account}
    attributes = Enum.into(attributes, @owner_attrs)
    {:ok, owner} = Ownerships.create_owner(session, attributes)

    {:ok, owner, account}
  end

  @cellar_attrs %{identifier: "some identifier", name: "some name"}

  def fixture(:cellar, attributes, _opts) do
    account = fixture(:seed_account)
    session = %Session{account: account}
    attributes = Enum.into(attributes, @cellar_attrs)
    {:ok, cellar} = Cellars.create_cellar(session, attributes)

    {:ok, cellar, account}
  end

  @lot_attrs %{identifier: "some identifier", notes: "some notes"}

  def fixture(:lot, attributes, _opts) do
    account = fixture(:seed_account)
    session = %Session{account: account}
    {:ok, cellar, _} = fixture(:cellar, %{identifier: "lot fixture cellar"})
    {:ok, owner, _} = fixture(:owner)
    {:ok, variety, _} = fixture(:variety)

    attributes =
      attributes
      |> Enum.into(@lot_attrs)
      |> Map.put(:cellar_id, cellar.id)
      |> Map.put(:owner_id, owner.id)
      |> Map.put(:variety_id, variety.id)

    {:ok, lot} = Lots.create_lot(session, attributes)

    {:ok, %{lot | cellar: cellar, owner: owner, variety: variety}, account}
  end

  @part_attrs %{amount: "100.00"}

  def fixture(:part, attributes, _opts) do
    account = fixture(:seed_account)
    session = %Session{account: account}
    {:ok, lot, _} = fixture(:lot)
    {:ok, vessel, _cellar, _} = fixture(:vessel)

    attributes =
      attributes
      |> Enum.into(@part_attrs)
      |> Map.put(:lot_id, lot.id)
      |> Map.put(:vessel_id, vessel.id)

    {:ok, part} = Lots.create_part(session, attributes)

    {:ok, %{part | lot: lot, vessel: vessel}, account}
  end

  @variety_attrs %{identifier: "some identifier", name: "some name", clone: "some clone"}

  def fixture(:variety, attributes, _opts) do
    account = fixture(:seed_account)
    session = %Session{account: account}
    attributes = Enum.into(attributes, @variety_attrs)
    {:ok, variety} = Options.create_variety(session, attributes)

    {:ok, variety, account}
  end

  @vessel_attrs %{
    capacity: "120.5000",
    cooling: "some cooling",
    identifier: "some identifier",
    material: "some material",
    notes: "some notes"
  }

  def fixture(:vessel, attributes, _opts) do
    account = fixture(:seed_account)
    session = %Session{account: account}
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
