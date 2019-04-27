defmodule Ptr.Support.Fixtures.MaterialFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Options

  defmacro __using__(_opts) do
    quote do
      @material_attrs %{name: "some name"}

      def fixture(:material, attributes, _opts) do
        account = fixture(:seed_account)
        session = %Session{account: account}
        attributes = Enum.into(attributes, @material_attrs)
        {:ok, material} = Options.create_material(session, attributes)

        {:ok, material, account}
      end
    end
  end
end
