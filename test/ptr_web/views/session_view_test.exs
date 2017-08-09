defmodule PtrWeb.SessionViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.SessionView

  import Phoenix.View

  test "renders new.html", %{conn: conn} do
    content = render_to_string(SessionView, "new.html", conn: conn)

    assert String.contains?(content, "Login")
  end
end
