defmodule PtrWeb.UserViewTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.UserView
  alias Ptr.Accounts
  alias Ptr.Accounts.User

  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    users   = [%User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com"},
               %User{id: "2", name: "Jane", lastname: "Doe", email: "jd@doe.com"}]
    content = render_to_string(UserView, "index.html",
                               conn: conn, users: users)

    for user <- users do
      assert String.contains?(content, user.email)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Accounts.change_user(%User{})
    content   = render_to_string(UserView, "new.html",
                                 conn: conn, changeset: changeset)

    assert String.contains?(content, "New user")
  end

  test "renders edit.html", %{conn: conn} do
    user      = %User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com"}
    changeset = Accounts.change_user(user)
    content   = render_to_string(UserView, "edit.html",
                                 conn: conn, user: user, changeset: changeset)

    assert String.contains?(content, user.email)
  end

  test "renders show.html", %{conn: conn} do
    user    = %User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com"}
    content = render_to_string(UserView, "show.html",
                                 conn: conn, user: user)

    assert String.contains?(content, user.email)
  end
end
