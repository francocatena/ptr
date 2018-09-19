defmodule Ptr.LotFixture do
  alias Ptr.Accounts.Session
  alias Ptr.Lots

  defmacro __using__(_opts) do
    quote do
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
    end
  end
end
