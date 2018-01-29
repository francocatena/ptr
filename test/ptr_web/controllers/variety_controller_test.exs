defmodule PtrWeb.VarietyControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{identifier: "some identifier", name: "some name", clone: "some clone"}
  @update_attrs %{
    identifier: "some updated identifier",
    name: "some updated name",
    clone: "some updated clone"
  }
  @invalid_attrs %{clone: nil, identifier: nil, name: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, variety_path(conn, :index)),
          get(conn, variety_path(conn, :new)),
          post(conn, variety_path(conn, :create, %{})),
          get(conn, variety_path(conn, :show, "123")),
          get(conn, variety_path(conn, :edit, "123")),
          put(conn, variety_path(conn, :update, "123", %{})),
          delete(conn, variety_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_variety]

    @tag login_as: "test@user.com"
    test "lists all varieties", %{conn: conn, variety: variety} do
      conn = get(conn, variety_path(conn, :index))
      response = html_response(conn, 200)

      assert response =~ "Varieties"
      assert response =~ variety.clone
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no varieties", %{conn: conn} do
      conn = get(conn, variety_path(conn, :index))

      assert html_response(conn, 200) =~ "you have no varieties"
    end
  end

  describe "new variety" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, variety_path(conn, :new))

      assert html_response(conn, 200) =~ "New variety"
    end
  end

  describe "create variety" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, variety_path(conn, :create), variety: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == variety_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, variety_path(conn, :create), variety: @invalid_attrs)

      assert html_response(conn, 200) =~ "New variety"
    end
  end

  describe "edit variety" do
    setup [:create_variety]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen variety", %{conn: conn, variety: variety} do
      conn = get(conn, variety_path(conn, :edit, variety))

      assert html_response(conn, 200) =~ "Edit variety"
    end
  end

  describe "update variety" do
    setup [:create_variety]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, variety: variety} do
      conn = put(conn, variety_path(conn, :update, variety), variety: @update_attrs)

      assert redirected_to(conn) == variety_path(conn, :show, variety)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, variety: variety} do
      conn = put(conn, variety_path(conn, :update, variety), variety: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit variety"
    end
  end

  describe "delete variety" do
    setup [:create_variety]

    @tag login_as: "test@user.com"
    test "deletes chosen variety", %{conn: conn, variety: variety} do
      conn = delete(conn, variety_path(conn, :delete, variety))

      assert redirected_to(conn) == variety_path(conn, :index)
    end
  end

  defp create_variety(_) do
    {:ok, variety, _} = fixture(:variety)

    {:ok, variety: variety}
  end
end
