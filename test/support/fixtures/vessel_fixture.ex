defmodule Ptr.Support.Fixtures.VesselFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Cellars

  defmacro __using__(_opts) do
    quote do
      @vessel_attrs %{
        capacity: "120.5000",
        cooling: "some cooling",
        identifier: "some identifier",
        notes: "some notes"
      }

      def fixture(:vessel, attributes, _opts) do
        account = fixture(:seed_account)
        session = %Session{account: account}
        {:ok, cellar, _} = fixture(:cellar, %{})
        {:ok, material, _} = fixture(:material, %{})

        create_vessel(session, cellar, material, attributes)
      end

      defp create_vessel(session, cellar, material, attributes) do
        attributes =
          attributes
          |> Enum.into(@vessel_attrs)
          |> Map.put(:cellar_id, cellar.id)
          |> Map.put(:material_id, material.id)

        {:ok, vessel} = Cellars.create_vessel(session, attributes)

        {:ok, %{vessel | cellar: cellar, material: material}, session.account}
      end
    end
  end
end
