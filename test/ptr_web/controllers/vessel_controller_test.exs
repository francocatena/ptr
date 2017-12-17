defmodule PtrWeb.VesselControllerTest do
  use PtrWeb.ConnCase
  use Ptr.Support.LoginHelper

  import Ptr.Support.FixtureHelper

  @create_attrs %{
    capacity: "120.5",
    cooling: "some cooling",
    identifier: "some identifier",
    material: "some material",
    notes: "some notes"
  }

  @update_attrs %{
    capacity: "456.7",
    cooling: "some updated cooling",
    identifier: "some updated identifier",
    material: "some updated material",
    notes: "some updated notes"
  }

  @invalid_attrs %{
    capacity: nil,
    cooling: nil,
    identifier: nil,
    material: nil,
    notes: nil
  }

  describe "unauthorized access" do
    test "requires user authentication on all actions", %{conn: conn} do
      Enum.each([
        get(conn,    cellar_vessel_path(conn, :index, "1")),
        get(conn,    cellar_vessel_path(conn, :new, "1")),
        post(conn,   cellar_vessel_path(conn, :create, "1", %{})),
        get(conn,    cellar_vessel_path(conn, :show, "1", "123")),
        get(conn,    cellar_vessel_path(conn, :edit, "1", "123")),
        put(conn,    cellar_vessel_path(conn, :update, "1", "123", %{})),
        delete(conn, cellar_vessel_path(conn, :delete, "1", "123"))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
    end
  end

  describe "index" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "lists all vessels", %{conn: conn, cellar: cellar, vessel: vessel} do
      conn     = get conn, cellar_vessel_path(conn, :index, cellar)
      response = html_response(conn, 200)

      assert response =~ "Vessels"
      assert response =~ vessel.identifier
    end

    @tag login_as: "test@user.com"
    test "lists vessels as JS", %{conn: conn, cellar: cellar, vessel: vessel} do
      conn =
        conn
        |> put_req_header("accept", "application/javascript")
        |> put_req_header("x-requested-with", "XMLHttpRequest")

      conn     = get conn, cellar_vessel_path(conn, :index, cellar)
      response = response(conn, 200)

      assert response =~ vessel.identifier
      assert response_content_type(conn, :js)
    end
  end

  describe "empty index" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "lists no vessels", %{conn: conn, cellar: cellar} do
      conn = get conn, cellar_vessel_path(conn, :index, cellar)

      assert html_response(conn, 200) =~ "you have no vessels"
    end
  end

  describe "new vessel" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "renders form", %{conn: conn, cellar: cellar} do
      conn = get conn, cellar_vessel_path(conn, :new, cellar)

      assert html_response(conn, 200) =~ "New vessel"
    end
  end

  describe "create vessel" do
    setup [:create_cellar]

    @tag login_as: "test@user.com"
    test "redirects to show when data is valid", %{conn: conn, cellar: cellar} do
      path = cellar_vessel_path(conn, :create, cellar)
      conn = post conn, path, vessel: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == cellar_vessel_path(conn, :show, cellar, id)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, cellar: cellar} do
      path = cellar_vessel_path(conn, :create, cellar)
      conn = post conn, path, vessel: @invalid_attrs

      assert html_response(conn, 200) =~ "New vessel"
    end
  end

  describe "edit vessel" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "renders form for editing chosen vessel", %{conn: conn, cellar: cellar, vessel: vessel} do
      conn = get conn, cellar_vessel_path(conn, :edit, cellar, vessel)

      assert html_response(conn, 200) =~ "Edit vessel"
    end
  end

  describe "update vessel" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "redirects when data is valid", %{conn: conn, cellar: cellar, vessel: vessel} do
      path = cellar_vessel_path(conn, :update, cellar, vessel)
      conn = put conn, path, vessel: @update_attrs

      assert redirected_to(conn) == cellar_vessel_path(conn, :show, cellar, vessel)
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, cellar: cellar, vessel: vessel} do
      path = cellar_vessel_path(conn, :update, cellar, vessel)
      conn = put conn, path, vessel: @invalid_attrs

      assert html_response(conn, 200) =~ "Edit vessel"
    end
  end

  describe "delete vessel" do
    setup [:create_vessel]

    @tag login_as: "test@user.com"
    test "deletes chosen vessel", %{conn: conn, cellar: cellar, vessel: vessel} do
      conn = delete conn, cellar_vessel_path(conn, :delete, cellar, vessel)

      assert redirected_to(conn) == cellar_vessel_path(conn, :index, cellar)
    end
  end

  defp create_vessel(_) do
    {:ok, vessel, cellar, _} = fixture(:vessel)

    {:ok, vessel: vessel, cellar: cellar}
  end

  def create_cellar(_) do
    {:ok, cellar, _} = fixture(:cellar)

    {:ok, cellar: cellar}
  end
end
