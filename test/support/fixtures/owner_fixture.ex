defmodule Ptr.OwnerFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Ownerships

  defmacro __using__(_opts) do
    quote do
      @owner_attrs %{name: "some name", tax_id: "some tax_id"}

      def fixture(:owner, attributes, _opts) do
        account = fixture(:seed_account)
        session = %Session{account: account}
        attributes = Enum.into(attributes, @owner_attrs)
        {:ok, owner} = Ownerships.create_owner(session, attributes)

        {:ok, owner, account}
      end
    end
  end
end
