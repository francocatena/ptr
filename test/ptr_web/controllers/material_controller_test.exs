defmodule PtrWeb.MaterialControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{lock_version: 42, name: "some name"}
  @update_attrs %{lock_version: 43, name: "some updated name"}
  @invalid_attrs %{lock_version: nil, name: nil}

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.material_path(conn, :index)),
          get(conn, Routes.material_path(conn, :new)),
          post(conn, Routes.material_path(conn, :create, %{})),
          get(conn, Routes.material_path(conn, :show, "123")),
          get(conn, Routes.material_path(conn, :edit, "123")),
          put(conn, Routes.material_path(conn, :update, "123", %{})),
          delete(conn, Routes.material_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_material]

    @tag login_as: "test@user.com"
    test "lists all materials", %{conn: conn, material: material} do
      conn = get(conn, Routes.material_path(conn, :index))
      response = html_response(conn, 200)

      assert response =~ "Materials"
      assert response =~ material.name
    end
  end

  describe "empty index" do
    @tag login_as: "test@user.com"
    test "lists no materials", %{conn: conn} do
      conn = get(conn, Routes.material_path(conn, :index))

      assert html_response(conn, 200) =~ "you have no materials"
    end
  end

  describe "new material" do
    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.material_path(conn, :new))

      assert html_response(conn, 200) =~ "New material"
    end
  end

  describe "create material" do
    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.material_path(conn, :create), material: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.material_path(conn, :show, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.material_path(conn, :create), material: @invalid_attrs

      assert html_response(conn, 200) =~ "New material"
    end
  end

  describe "edit material" do
    setup [:create_material]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen material", %{conn: conn, material: material} do
      conn = get(conn, Routes.material_path(conn, :edit, material))

      assert html_response(conn, 200) =~ "Edit material"
    end
  end

  describe "update material" do
    setup [:create_material]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, material: material} do
      conn = put conn, Routes.material_path(conn, :update, material), material: @update_attrs

      assert redirected_to(conn) == Routes.material_path(conn, :show, material)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, material: material} do
      conn = put conn, Routes.material_path(conn, :update, material), material: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit material"
    end
  end

  describe "delete material" do
    setup [:create_material]

    @tag login_as: "test@user.com"
    test "deletes chosen material", %{conn: conn, material: material} do
      conn = delete(conn, Routes.material_path(conn, :delete, material))

      assert redirected_to(conn) == Routes.material_path(conn, :index)
    end
  end

  defp create_material(_) do
    {:ok, material, _} = fixture(:material)

    {:ok, material: material}
  end
end
