defmodule PtrWeb.VarietyViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.VarietyView
  alias Ptr.Options
  alias Ptr.Options.Variety

  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "renders empty.html", %{conn: conn} do
    content = render_to_string(VarietyView, "empty.html", conn: conn)

    assert String.contains?(content, "you have no varieties")
  end

  test "renders index.html", %{conn: conn} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    varieties = [
      %Variety{id: "1", name: "Malbec", clone: "A clone"},
      %Variety{id: "2", name: "Cabernet", clone: "A clone"}
    ]

    content =
      render_to_string(VarietyView, "index.html", conn: conn, varieties: varieties, page: page)

    for variety <- varieties do
      assert String.contains?(content, variety.name)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = test_account() |> Options.change_variety(%Variety{})
    content = render_to_string(VarietyView, "new.html", conn: conn, changeset: changeset)

    assert String.contains?(content, "New variety")
  end

  test "renders edit.html", %{conn: conn} do
    variety = %Variety{id: "1", name: "Malbec", clone: "A clone"}
    changeset = test_account() |> Options.change_variety(variety)

    content =
      render_to_string(
        VarietyView,
        "edit.html",
        conn: conn,
        variety: variety,
        changeset: changeset
      )

    assert String.contains?(content, variety.name)
  end

  test "renders show.html", %{conn: conn} do
    variety = %Variety{id: "1", name: "Malbec", clone: "A clone"}
    content = render_to_string(VarietyView, "show.html", conn: conn, variety: variety)

    assert String.contains?(content, variety.name)
  end

  test "link to delete variety is empty when has lots", %{conn: conn} do
    variety = %Variety{id: "1", lots_count: 3}

    content =
      conn
      |> Plug.Conn.assign(:current_session, %{variety: variety})
      |> VarietyView.link_to_delete(variety)

    assert content == nil
  end

  test "link to delete variety is not empty when has no lots", %{conn: conn} do
    variety = %Variety{id: "1", lots_count: 0}

    content =
      conn
      |> VarietyView.link_to_delete(variety)
      |> safe_to_string

    refute content == nil
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
