defmodule Ptr.Cellars.VesselRepoTest do
  use Ptr.DataCase

  describe "vessel" do
    alias Ptr.Cellars.Vessel

    @valid_attrs %{
      capacity: "120.5000",
      cooling: "some cooling",
      identifier: "some identifier",
      material: "some material",
      notes: "some notes",
      cellar_id: "1"
    }

    test "converts unique constraint on identifier to error" do
      {:ok, vessel, _, account} = fixture(:vessel, @valid_attrs)
      attrs                     = %{@valid_attrs | identifier: vessel.identifier,
                                                   cellar_id: vessel.cellar_id}
      changeset                 = Vessel.changeset(account, %Vessel{}, attrs)
      prefix                    = Ptr.Accounts.prefix(account)
      {:error, changeset}       = Repo.insert(changeset, prefix: prefix)
      expected                  = {
        "has already been taken",
        [validation: :unsafe_unique, fields: [:identifier, :cellar_id]]
      }

      assert expected == changeset.errors[:identifier]
    end
  end
end

