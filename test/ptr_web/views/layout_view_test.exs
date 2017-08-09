defmodule PtrWeb.LayoutViewTest do
  use PtrWeb.ConnCase, async: true

  import Phoenix.HTML, only: [safe_to_string: 1]

  alias PtrWeb.LayoutView

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PtrWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "locale" do
    assert LayoutView.locale() == "en"
  end

  test "locale strips so it's ISO 639-1 _ish_" do
    Gettext.put_locale(PtrWeb.Gettext, "es_AR")

    assert LayoutView.locale() == "es"
  end

  describe "render flash" do
    test "return message template when present", %{conn: conn} do
      result =
        conn
        |> put_flash(:info, "Test")
        |> LayoutView.render_flash
        |> safe_to_string

      assert result =~ ~r/Test/
    end

    test "return empty string when no flash message", %{conn: conn} do
      assert LayoutView.render_flash(conn) == ""
    end
  end

  describe "flash class" do
    test "return CSS class name" do
      assert LayoutView.flash_class("info")  == "is-info"
      assert LayoutView.flash_class("error") == "is-danger"
    end
  end
end
