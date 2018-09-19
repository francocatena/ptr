defmodule Ptr.CellarFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Cellars

  defmacro __using__(_opts) do
    quote do
      @cellar_attrs %{identifier: "some identifier", name: "some name"}

      def fixture(:cellar, attributes, _opts) do
        account = fixture(:seed_account)
        session = %Session{account: account}
        attributes = Enum.into(attributes, @cellar_attrs)
        {:ok, cellar} = Cellars.create_cellar(session, attributes)

        {:ok, cellar, account}
      end
    end
  end
end
