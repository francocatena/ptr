defmodule PtrWeb.VesselControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{
    capacity: "120.5",
    cooling: "some cooling",
    identifier: "some identifier",
    notes: "some notes",
    material_id: "1"
  }

  @update_attrs %{
    capacity: "456.7",
    cooling: "some updated cooling",
    identifier: "some updated identifier",
    notes: "some updated notes"
  }

  @invalid_attrs %{
    capacity: nil,
    cooling: nil,
    identifier: nil,
    notes: nil
  }

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.cellar_vessel_path(conn, :index, "1")),
          get(conn, Routes.cellar_vessel_path(conn, :new, "1")),
          post(conn, Routes.cellar_vessel_path(conn, :create, "1", %{})),
          get(conn, Routes.cellar_vessel_path(conn, :show, "1", "123")),
          get(conn, Routes.cellar_vessel_path(conn, :edit, "1", "123")),
          put(conn, Routes.cellar_vessel_path(conn, :update, "1", "123", %{})),
          delete(conn, Routes.cellar_vessel_path(conn, :delete, "1", "123"))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "lists all vessels", %{conn: conn, vessel: vessel} do
      conn = get(conn, Routes.cellar_vessel_path(conn, :index, vessel.cellar))
      response = html_response(conn, 200)

      assert response =~ "Vessels"
      assert response =~ vessel.identifier
    end

    @tag login_as: "test@user.com"
    test "lists vessels as JS", %{conn: conn, vessel: vessel} do
      conn =
        conn
        |> put_req_header("accept", "application/javascript")
        |> put_req_header("x-requested-with", "XMLHttpRequest")

      conn = get(conn, Routes.cellar_vessel_path(conn, :index, vessel.cellar))
      response = response(conn, 200)

      assert response =~ vessel.identifier
      assert response_content_type(conn, :js)
    end
  end

  describe "empty index" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "lists no vessels", %{conn: conn, cellar: cellar} do
      conn = get(conn, Routes.cellar_vessel_path(conn, :index, cellar))

      assert html_response(conn, 200) =~ "you have no vessels"
    end
  end

  describe "new vessel" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn, cellar: cellar} do
      conn = get(conn, Routes.cellar_vessel_path(conn, :new, cellar))

      assert html_response(conn, 200) =~ "New vessel"
    end
  end

  describe "create vessel" do
    setup [:create_cellar_and_material]

    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn, cellar: cellar, material: material} do
      path = Routes.cellar_vessel_path(conn, :create, cellar)
      conn = post(conn, path, vessel: %{@create_attrs | material_id: material.id})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cellar_vessel_path(conn, :show, cellar, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, cellar: cellar} do
      path = Routes.cellar_vessel_path(conn, :create, cellar)
      conn = post(conn, path, vessel: @invalid_attrs)

      assert html_response(conn, 200) =~ "New vessel"
    end
  end

  describe "edit vessel" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen vessel", %{conn: conn, vessel: vessel} do
      conn = get(conn, Routes.cellar_vessel_path(conn, :edit, vessel.cellar, vessel))

      assert html_response(conn, 200) =~ "Edit vessel"
    end
  end

  describe "update vessel" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, vessel: vessel} do
      path = Routes.cellar_vessel_path(conn, :update, vessel.cellar, vessel)
      conn = put(conn, path, vessel: @update_attrs)

      assert redirected_to(conn) == Routes.cellar_vessel_path(conn, :show, vessel.cellar, vessel)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, vessel: vessel} do
      path = Routes.cellar_vessel_path(conn, :update, vessel.cellar, vessel)
      conn = put(conn, path, vessel: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit vessel"
    end
  end

  describe "delete vessel" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "deletes chosen vessel", %{conn: conn, vessel: vessel} do
      conn = delete(conn, Routes.cellar_vessel_path(conn, :delete, vessel.cellar, vessel))

      assert redirected_to(conn) == Routes.cellar_vessel_path(conn, :index, vessel.cellar)
    end
  end

  defp create_vessel(_) do
    {:ok, vessel, _} = fixture(:vessel)

    {:ok, vessel: vessel}
  end

  def create_cellar(_) do
    {:ok, cellar, _} = fixture(:cellar)

    {:ok, cellar: cellar}
  end

  def create_cellar_and_material(_) do
    {:ok, cellar, _} = fixture(:cellar)
    {:ok, material, _} = fixture(:material)

    {:ok, cellar: cellar, material: material}
  end
end
