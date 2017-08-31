defmodule PtrWeb.OwnerControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{name: "some name", tax_id: "some tax_id"}
  @update_attrs %{name: "some updated name", tax_id: "some updated tax_id"}
  @invalid_attrs %{name: nil, tax_id: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each([
        get(conn,    owner_path(conn, :index)),
        get(conn,    owner_path(conn, :new)),
        post(conn,   owner_path(conn, :create, %{})),
        get(conn,    owner_path(conn, :show, "123")),
        get(conn,    owner_path(conn, :edit, "123")),
        put(conn,    owner_path(conn, :update, "123", %{})),
        delete(conn, owner_path(conn, :delete, "123"))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
    end
  end

  describe "index" do
    @tag login_as: "test@user.com"
    test "lists all owners", %{conn: conn} do
      conn = get conn, owner_path(conn, :index)

      assert html_response(conn, 200) =~ "Owners"
    end
  end

  describe "new owner" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get conn, owner_path(conn, :new)

      assert html_response(conn, 200) =~ "New owner"
    end
  end

  describe "create owner" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, owner_path(conn, :create), owner: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == owner_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, owner_path(conn, :create), owner: @invalid_attrs

      assert html_response(conn, 200) =~ "New owner"
    end
  end

  describe "edit owner" do
    setup [:create_owner]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen owner", %{conn: conn, owner: owner} do
      conn = get conn, owner_path(conn, :edit, owner)

      assert html_response(conn, 200) =~ "Edit owner"
    end
  end

  describe "update owner" do
    setup [:create_owner]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, owner: owner} do
      conn = put conn, owner_path(conn, :update, owner), owner: @update_attrs

      assert redirected_to(conn) == owner_path(conn, :show, owner)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, owner: owner} do
      conn = put conn, owner_path(conn, :update, owner), owner: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit owner"
    end
  end

  describe "delete owner" do
    setup [:create_owner]

    @tag login_as: "test@user.com"
    test "deletes chosen owner", %{conn: conn, owner: owner} do
      conn = delete conn, owner_path(conn, :delete, owner)

      assert redirected_to(conn) == owner_path(conn, :index)
    end
  end

  defp create_owner(config) do
    {:ok, owner, _} = fixture(:owner, %{}, account: config[:account])

    {:ok, owner: owner}
  end
end
