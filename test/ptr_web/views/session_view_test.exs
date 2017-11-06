defmodule PtrWeb.SessionViewTest do
  use PtrWeb.ConnCase, async: true

  import Phoenix.View

  alias PtrWeb.SessionView

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PtrWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "renders new.html", %{conn: conn} do
    content = render_to_string(SessionView, "new.html", conn: conn)

    assert String.contains?(content, "Login")
  end
end
