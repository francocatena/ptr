defmodule PtrWeb.OwnerViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.OwnerView
  alias Ptr.Ownerships
  alias Ptr.Ownerships.Owner

  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "renders empty.html", %{conn: conn} do
    content = render_to_string(OwnerView, "empty.html", conn: conn)

    assert String.contains?(content, "you have no owners")
  end

  test "renders index.html", %{conn: conn} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    owners = [
      %Owner{id: "1", name: "Google", tax_id: "123"},
      %Owner{id: "2", name: "Twitter", tax_id: "234"}
    ]

    content = render_to_string(OwnerView, "index.html", conn: conn, owners: owners, page: page)

    for owner <- owners do
      assert String.contains?(content, owner.tax_id)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = test_account() |> Ownerships.change_owner(%Owner{})
    content = render_to_string(OwnerView, "new.html", conn: conn, changeset: changeset)

    assert String.contains?(content, "New owner")
  end

  test "renders edit.html", %{conn: conn} do
    owner = %Owner{id: "1", name: "Google", tax_id: "123"}
    changeset = test_account() |> Ownerships.change_owner(owner)

    content =
      render_to_string(OwnerView, "edit.html", conn: conn, owner: owner, changeset: changeset)

    assert String.contains?(content, owner.tax_id)
  end

  test "renders show.html", %{conn: conn} do
    owner = %Owner{id: "1", name: "Google", tax_id: "123"}
    content = render_to_string(OwnerView, "show.html", conn: conn, owner: owner)

    assert String.contains?(content, owner.tax_id)
  end

  test "link to delete owner is empty when has lots", %{conn: conn} do
    owner = %Owner{id: "1", lots_count: 3}

    content =
      conn
      |> Plug.Conn.assign(:current_session, %{owner: owner})
      |> OwnerView.link_to_delete(owner)

    assert content == ""
  end

  test "link to delete owner is not empty when has no lots", %{conn: conn} do
    owner = %Owner{id: "1", lots_count: 0}

    content =
      conn
      |> OwnerView.link_to_delete(owner)
      |> safe_to_string

    refute content == ""
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
