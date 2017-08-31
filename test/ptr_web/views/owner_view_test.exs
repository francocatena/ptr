defmodule PtrWeb.OwnerViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.OwnerView
  alias Ptr.Ownerships
  alias Ptr.Ownerships.Owner

  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    page    = %Scrivener.Page{total_pages: 1, page_number: 1}
    owners  = [%Owner{id: "1", name: "Google", tax_id: "123"},
               %Owner{id: "2", name: "Twitter", tax_id: "234"}]
    content = render_to_string(OwnerView, "index.html",
                               conn: conn, owners: owners, page: page)

    for owner <- owners do
      assert String.contains?(content, owner.tax_id)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Ownerships.change_owner(%Owner{})
    content   = render_to_string(OwnerView, "new.html",
                                 conn: conn, changeset: changeset)

    assert String.contains?(content, "New owner")
  end

  test "renders edit.html", %{conn: conn} do
    owner     = %Owner{id: "1", name: "Google", tax_id: "123"}
    changeset = Ownerships.change_owner(owner)
    content   = render_to_string(OwnerView, "edit.html",
                                 conn: conn, owner: owner, changeset: changeset)

    assert String.contains?(content, owner.tax_id)
  end

  test "renders show.html", %{conn: conn} do
    owner   = %Owner{id: "1", name: "Google", tax_id: "123"}
    content = render_to_string(OwnerView, "show.html",
                                 conn: conn, owner: owner)

    assert String.contains?(content, owner.tax_id)
  end
end
