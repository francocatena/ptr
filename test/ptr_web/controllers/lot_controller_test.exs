defmodule PtrWeb.LotControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{
    identifier: "some identifier",
    notes: "some notes",
    cellar_id: 1,
    owner_id: 1,
    variety_id: 1
  }
  @update_attrs %{identifier: "some updated identifier", notes: "some updated notes"}
  @invalid_attrs %{identifier: nil, notes: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, lot_path(conn, :index)),
          get(conn, lot_path(conn, :new)),
          post(conn, lot_path(conn, :create, %{})),
          get(conn, lot_path(conn, :show, "123")),
          get(conn, lot_path(conn, :edit, "123")),
          put(conn, lot_path(conn, :update, "123", %{})),
          delete(conn, lot_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_lot]

    @tag login_as: "test@user.com"
    test "lists all lots", %{conn: conn, lot: lot} do
      conn = get(conn, lot_path(conn, :index))
      response = html_response(conn, 200)

      assert response =~ "Lots"
      assert response =~ lot.identifier
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no lots", %{conn: conn} do
      conn = get(conn, lot_path(conn, :index))

      assert html_response(conn, 200) =~ "you have no lots"
    end
  end

  describe "new lot" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, lot_path(conn, :new))

      assert html_response(conn, 200) =~ "New lot"
    end
  end

  describe "create lot" do
    setup [:create_cellar_owner_and_variety]

    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{
      conn: conn,
      cellar: cellar,
      owner: owner,
      variety: variety
    } do
      attrs = %{@create_attrs | cellar_id: cellar.id, owner_id: owner.id, variety_id: variety.id}
      conn = post(conn, lot_path(conn, :create), lot: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == lot_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, lot_path(conn, :create), lot: @invalid_attrs)

      assert html_response(conn, 200) =~ "New lot"
    end
  end

  describe "edit lot" do
    setup [:create_lot]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen lot", %{conn: conn, lot: lot} do
      conn = get(conn, lot_path(conn, :edit, lot))

      assert html_response(conn, 200) =~ "Edit lot"
    end
  end

  describe "update lot" do
    setup [:create_lot]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, lot: lot} do
      conn = put(conn, lot_path(conn, :update, lot), lot: @update_attrs)

      assert redirected_to(conn) == lot_path(conn, :show, lot)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, lot: lot} do
      conn = put(conn, lot_path(conn, :update, lot), lot: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit lot"
    end
  end

  describe "delete lot" do
    setup [:create_lot]

    @tag login_as: "test@user.com"
    test "deletes chosen lot", %{conn: conn, lot: lot} do
      conn = delete(conn, lot_path(conn, :delete, lot))

      assert redirected_to(conn) == lot_path(conn, :index)
    end
  end

  defp create_cellar_owner_and_variety(_) do
    {:ok, cellar, _} = fixture(:cellar, %{identifier: "lot cellar"})
    {:ok, owner, _} = fixture(:owner)
    {:ok, variety, _} = fixture(:variety)

    {:ok, cellar: cellar, owner: owner, variety: variety}
  end

  defp create_lot(_) do
    {:ok, lot, _} = fixture(:lot)

    {:ok, lot: lot}
  end
end
