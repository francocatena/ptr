defmodule PtrWeb.LotViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.LotView
  alias Ptr.Lots
  alias Ptr.Lots.Lot
  alias Ptr.Options.Variety
  alias Ptr.Ownerships.Owner

  import Phoenix.View

  test "renders empty.html", %{conn: conn} do
    content = render_to_string(LotView, "empty.html", conn: conn)

    assert String.contains?(content, "you have no lots")
  end

  test "renders index.html", %{conn: conn} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    lots = [
      %Lot{
        id: "1",
        identifier: "one",
        owner: %Owner{id: "1", name: "Google"},
        variety: %Variety{id: "1", name: "Malbec"}
      },
      %Lot{
        id: "2",
        identifier: "two",
        owner: %Owner{id: "1", name: "Google"},
        variety: %Variety{id: "1", name: "Malbec"}
      }
    ]

    content = render_to_string(LotView, "index.html", conn: conn, lots: lots, page: page)

    for lot <- lots do
      assert String.contains?(content, lot.identifier)
    end
  end

  test "renders new.html", %{conn: conn} do
    account = test_account()
    changeset = account |> Lots.change_lot(%Lot{})

    content =
      render_to_string(LotView, "new.html", conn: conn, account: account, changeset: changeset)

    assert String.contains?(content, "New lot")
  end

  test "renders edit.html", %{conn: conn} do
    lot = %Lot{
      id: "1",
      identifier: "one",
      owner: %Owner{id: "1", name: "Google"},
      variety: %Variety{id: "1", name: "Malbec"}
    }

    account = test_account()
    changeset = account |> Lots.change_lot(lot)

    content =
      render_to_string(
        LotView,
        "edit.html",
        conn: conn,
        account: account,
        lot: lot,
        changeset: changeset
      )

    assert String.contains?(content, lot.identifier)
  end

  test "renders show.html", %{conn: conn} do
    lot = %Lot{
      id: "1",
      identifier: "one",
      owner: %Owner{id: "1", name: "Google"},
      variety: %Variety{id: "1", name: "Malbec"}
    }

    content =
      render_to_string(
        LotView,
        "show.html",
        conn: conn,
        lot: lot,
        account: test_account()
      )

    assert String.contains?(content, lot.identifier)
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
