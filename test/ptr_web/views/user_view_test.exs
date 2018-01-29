defmodule PtrWeb.UserViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.UserView
  alias Ptr.Accounts
  alias Ptr.Accounts.User

  import Phoenix.View
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "renders index.html", %{conn: conn} do
    page = %Scrivener.Page{total_pages: 1, page_number: 1}

    users = [
      %User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com"},
      %User{id: "2", name: "Jane", lastname: "Doe", email: "jd@doe.com"}
    ]

    content = render_to_string(UserView, "index.html", conn: conn, users: users, page: page)

    for user <- users do
      assert String.contains?(content, user.email)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Accounts.change_user(%User{})
    content = render_to_string(UserView, "new.html", conn: conn, changeset: changeset)

    assert String.contains?(content, "New user")
  end

  test "renders edit.html", %{conn: conn} do
    user = %User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com"}
    changeset = Accounts.change_user(user)

    content =
      render_to_string(UserView, "edit.html", conn: conn, user: user, changeset: changeset)

    assert String.contains?(content, user.email)
  end

  test "renders show.html", %{conn: conn} do
    user = %User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com"}
    content = render_to_string(UserView, "show.html", conn: conn, user: user)

    assert String.contains?(content, user.email)
  end

  test "link to delete user is disabled when current user", %{conn: conn} do
    user = %User{id: "1"}

    content =
      conn
      |> Plug.Conn.assign(:current_session, %{user: user})
      |> UserView.link_to_delete(user)
      |> safe_to_string

    assert content =~ "disabled"
  end

  test "link to delete user is not disabled when no current user", %{conn: conn} do
    user = %User{id: "1"}

    content =
      conn
      |> UserView.link_to_delete(user)
      |> safe_to_string

    refute content =~ "disabled"
  end
end
