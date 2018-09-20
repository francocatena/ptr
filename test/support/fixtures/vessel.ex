defmodule Ptr.Support.Fixtures.Vessel do
  alias Ptr.Accounts.Session
  alias Ptr.Cellars

  defmacro __using__(_opts) do
    quote do
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
  end
end
