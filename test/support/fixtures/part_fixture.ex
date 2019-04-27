defmodule Ptr.Support.Fixtures.PartFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Lots

  defmacro __using__(_opts) do
    quote do
      @part_attrs %{amount: "100.00"}

      def fixture(:part, attributes, _opts) do
        account = fixture(:seed_account)
        session = %Session{account: account}
        {:ok, lot, _} = fixture(:lot)
        {:ok, vessel, _} = fixture(:vessel)

        attributes =
          attributes
          |> Enum.into(@part_attrs)
          |> Map.put(:lot_id, lot.id)
          |> Map.put(:vessel_id, vessel.id)

        {:ok, part} = Lots.create_part(session, attributes)

        {:ok, %{part | lot: lot, vessel: vessel}, account}
      end
    end
  end
end
