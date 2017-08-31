defmodule Ptr.Support.LoginHelper do
  use ExUnit.CaseTemplate
  use Phoenix.ConnTest

  import Ptr.Support.FixtureHelper

  alias Ptr.Accounts.User

  using do
    quote do
      import Ptr.Support.LoginHelper

      setup %{conn: conn} = config do
        do_setup conn, config[:login_as]
      end
    end
  end

  def do_setup(_, nil), do: :ok
  def do_setup(conn, email) do
    account = fixture(:account, %{}, create_schema: true)
    user    = %User{email: email, account_id: account.id}
    conn    =
      conn
      |> assign(:current_account, account)
      |> assign(:current_user, user)

    {:ok, conn: conn, account: account, user: user}
  end
end
