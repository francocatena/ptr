defmodule PtrWeb.PartViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.PartView
  alias Ptr.Lots
  alias Ptr.Lots.{Lot, Part}
  alias Ptr.Cellars.Vessel

  import Phoenix.View

  test "renders empty.html", %{conn: conn} do
    lot = %Lot{id: "1", identifier: "one"}
    content = render_to_string(PartView, "empty.html", lot: lot, conn: conn)

    assert String.contains?(content, "you have no parts")
  end

  test "renders index.html", %{conn: conn} do
    lot = %Lot{id: "1", identifier: "one"}
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    parts = [
      %Part{
        id: "1",
        amount: Decimal.new("100"),
        lot: lot,
        vessel: %Vessel{id: "1", identifier: "41"}
      },
      %Part{
        id: "2",
        amount: Decimal.new("200"),
        lot: lot,
        vessel: %Vessel{id: "2", identifier: "43"}
      }
    ]

    content =
      render_to_string(PartView, "index.html", conn: conn, lot: lot, parts: parts, page: page)

    for part <- parts do
      assert String.contains?(content, Decimal.to_string(part.amount))
    end
  end

  test "renders new.html", %{conn: conn} do
    account = test_account()
    changeset = account |> Lots.change_part(%Part{})

    lot = %Lot{
      id: "1",
      identifier: "one",
      cellar: %Ptr.Cellars.Cellar{id: "1", identifier: "gallo", name: "Gallo"}
    }

    content =
      render_to_string(
        PartView,
        "new.html",
        conn: conn,
        account: account,
        lot: lot,
        changeset: changeset
      )

    assert String.contains?(content, "New part")
  end

  test "renders edit.html", %{conn: conn} do
    account = test_account()

    lot = %Lot{
      id: "1",
      identifier: "one",
      cellar: %Ptr.Cellars.Cellar{id: "1", identifier: "gallo", name: "Gallo"}
    }

    part = %Part{
      id: "1",
      amount: Decimal.new("100"),
      lot: lot,
      vessel: %Vessel{id: "1", identifier: "42"}
    }

    changeset = Lots.change_part(account, part)

    content =
      render_to_string(
        PartView,
        "edit.html",
        conn: conn,
        account: account,
        lot: lot,
        part: part,
        changeset: changeset
      )

    assert String.contains?(content, Decimal.to_string(part.amount))
  end

  test "renders show.html", %{conn: conn} do
    lot = %Lot{id: "1", identifier: "one"}

    part = %Part{
      id: "1",
      amount: Decimal.new("100"),
      lot: lot,
      vessel: %Vessel{
        id: "1",
        identifier: "42",
        cellar_id: "1"
      }
    }

    content =
      render_to_string(
        PartView,
        "show.html",
        lot: lot,
        part: part,
        conn: conn
      )

    assert String.contains?(content, Decimal.to_string(part.amount))
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
