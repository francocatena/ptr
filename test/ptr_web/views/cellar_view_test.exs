defmodule PtrWeb.CellarViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.CellarView
  alias Ptr.Cellars
  alias Ptr.Cellars.Cellar

  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    page    = %Scrivener.Page{total_pages: 1, page_number: 1}
    cellars = [%Cellar{id: "1", identifier: "gallo", name: "Gallo"},
               %Cellar{id: "2", identifier: "conti", name: "Romanée-Conti"}]
    content = render_to_string(CellarView, "index.html",
                               conn: conn, cellars: cellars, page: page)

    for cellar <- cellars do
      assert String.contains?(content, cellar.identifier)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = test_account() |> Cellars.change_cellar(%Cellar{})
    content   = render_to_string(CellarView, "new.html",
                                 conn: conn, changeset: changeset)

    assert String.contains?(content, "New cellar")
  end

  test "renders edit.html", %{conn: conn} do
    cellar    = %Cellar{id: "1", identifier: "gallo", name: "Gallo"}
    changeset = test_account() |> Cellars.change_cellar(cellar)
    content   = render_to_string(CellarView, "edit.html",
                                 conn: conn, cellar: cellar, changeset: changeset)

    assert String.contains?(content, cellar.identifier)
  end

  test "renders show.html", %{conn: conn} do
    cellar  = %Cellar{id: "1", identifier: "gallo", name: "Gallo"}
    content = render_to_string(CellarView, "show.html",
                                 conn: conn, cellar: cellar)

    assert String.contains?(content, cellar.identifier)
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
