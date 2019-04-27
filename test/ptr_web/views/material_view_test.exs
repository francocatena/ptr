defmodule PtrWeb.MaterialViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.MaterialView
  alias Ptr.Options
  alias Ptr.Options.Material

  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "renders empty.html", %{conn: conn} do
    content = render_to_string(MaterialView, "empty.html", conn: conn)

    assert String.contains?(content, "you have no materials")
  end

  test "renders index.html", %{conn: conn} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    materials = [
      %Material{id: "1", name: "Concrete"},
      %Material{id: "2", name: "Steel"}
    ]

    content =
      render_to_string(MaterialView, "index.html", conn: conn, materials: materials, page: page)

    for material <- materials do
      assert String.contains?(content, material.name)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = test_account() |> Options.change_material(%Material{})
    content = render_to_string(MaterialView, "new.html", conn: conn, changeset: changeset)

    assert String.contains?(content, "New material")
  end

  test "renders edit.html", %{conn: conn} do
    material = %Material{id: "1", name: "Concrete"}
    changeset = test_account() |> Options.change_material(material)

    content =
      render_to_string(
        MaterialView,
        "edit.html",
        conn: conn,
        material: material,
        changeset: changeset
      )

    assert String.contains?(content, material.name)
  end

  test "renders show.html", %{conn: conn} do
    material = %Material{id: "1", name: "Concrete"}
    content = render_to_string(MaterialView, "show.html", conn: conn, material: material)

    assert String.contains?(content, material.name)
  end

  test "link to delete material is empty when has vessels", %{conn: conn} do
    material = %Material{id: "1", vessels_count: 3}

    content =
      conn
      |> Plug.Conn.assign(:current_session, %{material: material})
      |> MaterialView.link_to_delete(material)

    assert content == nil
  end

  test "link to delete material is not empty when has no vessels", %{conn: conn} do
    material = %Material{id: "1", vessels_count: 0}

    content =
      conn
      |> MaterialView.link_to_delete(material)
      |> safe_to_string

    refute content == nil
  end

  defp test_account do
    %Ptr.Accounts.Account{db_prefix: "test_account"}
  end
end
