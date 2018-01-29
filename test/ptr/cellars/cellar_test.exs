defmodule Ptr.Cellars.CellarTest do
  use Ptr.DataCase, async: true

  describe "cellar" do
    alias Ptr.Cellars.Cellar

    @valid_attrs %{identifier: "some identifier", name: "some name"}
    @invalid_attrs %{identifier: nil, name: nil}

    test "changeset with valid attributes" do
      changeset = test_account() |> Cellar.changeset(%Cellar{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = test_account() |> Cellar.changeset(%Cellar{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:name, String.duplicate("a", 256))
        |> Map.put(:identifier, String.duplicate("a", 256))

      changeset = test_account() |> Cellar.changeset(%Cellar{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).name
      assert "should be at most 255 character(s)" in errors_on(changeset).identifier
    end
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
