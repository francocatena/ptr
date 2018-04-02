defmodule Ptr.Cellars.VesselTest do
  use Ptr.DataCase, async: true

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

    @invalid_attrs %{
      capacity: nil,
      cooling: nil,
      identifier: nil,
      material: nil,
      notes: nil
    }

    test "changeset with valid attributes" do
      changeset = test_account() |> Vessel.changeset(%Vessel{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Vessel.changeset(%Vessel{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:identifier, String.duplicate("a", 256))
        |> Map.put(:material, String.duplicate("a", 256))
        |> Map.put(:cooling, String.duplicate("a", 256))

      changeset = test_account() |> Vessel.changeset(%Vessel{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).identifier
      assert "should be at most 255 character(s)" in errors_on(changeset).material
      assert "should be at most 255 character(s)" in errors_on(changeset).cooling
    end

    test "changeset validates capacity number boundaries" do
      attrs = @valid_attrs |> Map.put(:capacity, -1)

      changeset = test_account() |> Vessel.changeset(%Vessel{}, attrs)

      assert "must be greater than 0" in errors_on(changeset).capacity

      attrs = @valid_attrs |> Map.put(:capacity, 1_000_000)

      changeset = test_account() |> Vessel.changeset(%Vessel{}, attrs)

      assert "must be less than 1000000" in errors_on(changeset).capacity
    end

    test "changeset validates capacity is never less than usage" do
      attrs = @valid_attrs |> Map.put(:capacity, 20_000)

      changeset = test_account() |> Vessel.changeset(%Vessel{usage: 30_000}, attrs)

      assert "must be greater than or equal to 30000" in errors_on(changeset).capacity
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
