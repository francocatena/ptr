defmodule PtrWeb.VesselViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.VesselView
  alias Ptr.Cellars
  alias Ptr.Cellars.{Cellar, Vessel}

  import Phoenix.View

  setup %{conn: conn} do
    cellar = %Cellar{id: "1", identifier: "gallo", name: "Gallo"}

    {:ok, %{conn: conn, cellar: cellar}}
  end

  test "renders empty.html", %{conn: conn, cellar: cellar} do
    content = render_to_string(VesselView, "empty.html",
                               conn: conn, cellar: cellar)

    assert String.contains?(content, "you have no vessels")
  end

  test "renders index.html", %{conn: conn, cellar: cellar} do
    page    = %Scrivener.Page{total_pages: 1, page_number: 1}
    vessels = [
      %Vessel{
        id: "1",
        identifier: "1a",
        capacity: Decimal.new("100"),
        cellar_id: cellar.id
      },
      %Vessel{
        id: "2",
        identifier: "2a",
        capacity: Decimal.new("200"),
        cellar_id: cellar.id
      }
    ]

    content = render_to_string(VesselView, "index.html", conn: conn,
                                                         cellar: cellar,
                                                         vessels: vessels,
                                                         page: page)

    for vessel <- vessels do
      assert String.contains?(content, vessel.identifier)
    end
  end

  test "renders new.html", %{conn: conn, cellar: cellar} do
    changeset = test_account() |> Cellars.change_vessel(%Vessel{})
    content   = render_to_string(VesselView, "new.html", conn: conn,
                                                         cellar: cellar,
                                                         changeset: changeset)

    assert String.contains?(content, "New vessel")
  end

  test "renders edit.html", %{conn: conn, cellar: cellar} do
    vessel    = %Vessel{
      id: "1",
      identifier: "1a",
      capacity: Decimal.new("100"),
      cellar_id: cellar.id
    }
    changeset = test_account() |> Cellars.change_vessel(vessel)
    content   = render_to_string(VesselView, "edit.html", conn: conn,
                                                          cellar: cellar,
                                                          vessel: vessel,
                                                          changeset: changeset)

    assert String.contains?(content, vessel.identifier)
  end

  test "renders show.html", %{conn: conn, cellar: cellar} do
    vessel  = %Vessel{
      id: "1",
      identifier: "1a",
      capacity: Decimal.new("100"),
      cellar_id: cellar.id
    }
    content = render_to_string(VesselView, "show.html",
                               conn: conn, cellar: cellar, vessel: vessel)

    assert String.contains?(content, vessel.identifier)
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
