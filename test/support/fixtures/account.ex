defmodule Ptr.Support.Fixtures.Account do
  alias Ptr.Accounts
  alias Ptr.Accounts.Account
  alias Ptr.Repo

  defmacro __using__(_opts) do
    quote do
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
    end
  end
end
