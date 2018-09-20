defmodule Ptr.Support.Fixtures.VarietyFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Options

  defmacro __using__(_opts) do
    quote do
      @variety_attrs %{identifier: "some identifier", name: "some name", clone: "some clone"}

      def fixture(:variety, attributes, _opts) do
        account = fixture(:seed_account)
        session = %Session{account: account}
        attributes = Enum.into(attributes, @variety_attrs)
        {:ok, variety} = Options.create_variety(session, attributes)

        {:ok, variety, account}
      end
    end
  end
end
