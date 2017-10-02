defmodule PtrWeb.CellarControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{identifier: "some identifier", name: "some name"}
  @update_attrs %{identifier: "some updated identifier", name: "some updated name"}
  @invalid_attrs %{identifier: nil, name: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each([
        get(conn,    cellar_path(conn, :index)),
        get(conn,    cellar_path(conn, :new)),
        post(conn,   cellar_path(conn, :create, %{})),
        get(conn,    cellar_path(conn, :show, "123")),
        get(conn,    cellar_path(conn, :edit, "123")),
        put(conn,    cellar_path(conn, :update, "123", %{})),
        delete(conn, cellar_path(conn, :delete, "123"))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
    end
  end

  describe "index" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "lists all cellars", %{conn: conn, cellar: cellar} do
      conn     = get conn, cellar_path(conn, :index)
      response = html_response(conn, 200)

      assert response =~ "Cellars"
      assert response =~ cellar.name
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no cellars", %{conn: conn} do
      conn = get conn, cellar_path(conn, :index)

      assert html_response(conn, 200) =~ "you have no cellars"
    end
  end

  describe "new cellar" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get conn, cellar_path(conn, :new)

      assert html_response(conn, 200) =~ "New cellar"
    end
  end

  describe "create cellar" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, cellar_path(conn, :create), cellar: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == cellar_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, cellar_path(conn, :create), cellar: @invalid_attrs

      assert html_response(conn, 200) =~ "New cellar"
    end
  end

  describe "edit cellar" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen cellar", %{conn: conn, cellar: cellar} do
      conn = get conn, cellar_path(conn, :edit, cellar)

      assert html_response(conn, 200) =~ "Edit cellar"
    end
  end

  describe "update cellar" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, cellar: cellar} do
      conn = put conn, cellar_path(conn, :update, cellar), cellar: @update_attrs

      assert redirected_to(conn) == cellar_path(conn, :show, cellar)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, cellar: cellar} do
      conn = put conn, cellar_path(conn, :update, cellar), cellar: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit cellar"
    end
  end

  describe "delete cellar" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "deletes chosen cellar", %{conn: conn, cellar: cellar} do
      conn = delete conn, cellar_path(conn, :delete, cellar)

      assert redirected_to(conn) == cellar_path(conn, :index)
    end
  end

  defp create_cellar(_) do
    {:ok, cellar, _} = fixture(:cellar)

    {:ok, cellar: cellar}
  end
end
