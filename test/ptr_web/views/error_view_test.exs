defmodule PtrWeb.ErrorViewTest do
  use PtrWeb.ConnCase, async: true

  import Phoenix.View, only: [render_to_string: 3]

  test "renders 404.html" do
    assert render_to_string(PtrWeb.ErrorView, "404.html", []) =~ "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(PtrWeb.ErrorView, "500.html", []) =~ "Internal server error"
  end

  test "render any other" do
    assert render_to_string(PtrWeb.ErrorView, "505.html", []) =~ "Internal server error"
  end
end
