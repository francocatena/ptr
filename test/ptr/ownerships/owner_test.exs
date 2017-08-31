defmodule Ptr.Ownerships.OwnerTest do
  use Ptr.DataCase, async: true

  describe "owner" do
    alias Ptr.Ownerships.Owner

    @valid_attrs   %{name: "some name", tax_id: "123456"}
    @invalid_attrs %{name: nil, tax_id: nil}

    test "changeset with valid attributes" do
      changeset = Owner.changeset(%Owner{}, @valid_attrs)

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Owner.changeset(%Owner{}, @invalid_attrs)

      refute changeset.valid?
    end

    test "changeset does not accept long attributes" do
      attrs =
        @valid_attrs
        |> Map.put(:name, String.duplicate("a", 256))
        |> Map.put(:tax_id, String.duplicate("a", 256))

      changeset = Owner.changeset(%Owner{}, attrs)

      assert "should be at most 255 character(s)" in errors_on(changeset).name
      assert "should be at most 255 character(s)" in errors_on(changeset).tax_id
    end
  end
end

