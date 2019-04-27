defmodule Ptr.Options.MaterialTest do
  use Ptr.DataCase, async: true

  describe "material" do
    alias Ptr.Options.Material

    @valid_attrs %{name: "some name"}
    @invalid_attrs %{name: nil}

    test "changeset with valid attributes" do
      changeset = test_account() |> Material.changeset(%Material{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Material.changeset(%Material{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:name, String.duplicate("a", 256))

      changeset = test_account() |> Material.changeset(%Material{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).name
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
