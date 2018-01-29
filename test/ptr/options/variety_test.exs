defmodule Ptr.Options.VarietyTest do
  use Ptr.DataCase, async: true

  describe "variety" do
    alias Ptr.Options.Variety

    @valid_attrs %{identifier: "some identifier", name: "some name", clone: "some clone"}
    @invalid_attrs %{identifier: nil, name: nil, clone: nil}

    test "changeset with valid attributes" do
      changeset = test_account() |> Variety.changeset(%Variety{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Variety.changeset(%Variety{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:identifier, String.duplicate("a", 256))
        |> Map.put(:name, String.duplicate("a", 256))
        |> Map.put(:clone, String.duplicate("a", 256))

      changeset = test_account() |> Variety.changeset(%Variety{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).identifier
      assert "should be at most 255 character(s)" in errors_on(changeset).name
      assert "should be at most 255 character(s)" in errors_on(changeset).clone
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
