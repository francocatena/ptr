defmodule PtrWeb.PartControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{amount: "120.5", lot_id: 1, vessel_id: 1}
  @update_attrs %{amount: "111.4"}
  @invalid_attrs %{amount: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.lot_part_path(conn, :index, "1")),
          get(conn, Routes.lot_part_path(conn, :new, "1")),
          post(conn, Routes.lot_part_path(conn, :create, "1", %{})),
          get(conn, Routes.lot_part_path(conn, :show, "1", "123")),
          get(conn, Routes.lot_part_path(conn, :edit, "1", "123")),
          put(conn, Routes.lot_part_path(conn, :update, "1", "123", %{})),
          delete(conn, Routes.lot_part_path(conn, :delete, "1", "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_part]

    @tag login_as: "test@user.com"
    test "lists all parts", %{conn: conn, part: part} do
      conn = get(conn, Routes.lot_part_path(conn, :index, part.lot))
      response = html_response(conn, 200)

      assert response =~ "Parts"
      assert response =~ Decimal.to_string(Decimal.round(part.amount))
    end
  end

  describe "empty index" do
    setup [:create_lot]

    @tag login_as: "test@user.com"
    test "lists no parts", %{conn: conn, lot: lot} do
      conn = get(conn, Routes.lot_part_path(conn, :index, lot))

      assert html_response(conn, 200) =~ "you have no parts"
    end
  end

  describe "new part" do
    setup [:create_lot]

    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn, lot: lot} do
      conn = get(conn, Routes.lot_part_path(conn, :new, lot))

      assert html_response(conn, 200) =~ "New part"
    end
  end

  describe "create part" do
    setup [:create_lot_and_vessel]

    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn, lot: lot, vessel: vessel} do
      attrs = %{@create_attrs | lot_id: lot.id, vessel_id: vessel.id}
      conn = post(conn, Routes.lot_part_path(conn, :create, lot), part: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.lot_part_path(conn, :show, lot, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, lot: lot} do
      conn = post(conn, Routes.lot_part_path(conn, :create, lot), part: @invalid_attrs)

      assert html_response(conn, 200) =~ "New part"
    end
  end

  describe "edit part" do
    setup [:create_part]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen part", %{conn: conn, part: part} do
      conn = get(conn, Routes.lot_part_path(conn, :edit, part.lot, part))

      assert html_response(conn, 200) =~ "Edit part"
    end
  end

  describe "update part" do
    setup [:create_part]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, part: part} do
      conn = put(conn, Routes.lot_part_path(conn, :update, part.lot, part), part: @update_attrs)

      assert redirected_to(conn) == Routes.lot_part_path(conn, :show, part.lot, part)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, part: part} do
      conn = put(conn, Routes.lot_part_path(conn, :update, part.lot, part), part: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit part"
    end
  end

  describe "delete part" do
    setup [:create_part]

    @tag login_as: "test@user.com"
    test "deletes chosen part", %{conn: conn, part: part} do
      conn = delete(conn, Routes.lot_part_path(conn, :delete, part.lot, part))

      assert redirected_to(conn) == Routes.lot_part_path(conn, :index, part.lot)
    end
  end

  defp create_lot(_) do
    {:ok, lot, _} = fixture(:lot)

    {:ok, lot: lot}
  end

  defp create_lot_and_vessel(_) do
    {:ok, lot, _} = fixture(:lot)
    {:ok, vessel, _} = fixture(:vessel)

    {:ok, lot: lot, vessel: vessel}
  end

  defp create_part(_) do
    {:ok, part, _} = fixture(:part)

    {:ok, part: part}
  end
end
