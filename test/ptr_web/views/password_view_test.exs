defmodule PtrWeb.PasswordViewTest do
  use PtrWeb.ConnCase, async: true

  alias Ptr.Accounts
  alias Ptr.Accounts.User
  alias PtrWeb.PasswordView

  import Phoenix.View

  test "renders new.html", %{conn: conn} do
    content = render_to_string(PasswordView, "new.html", conn: conn)

    assert String.contains?(content, "Forgot your password?")
  end

  test "renders edit.html", %{conn: conn} do
    user      = %User{id: "1", name: "John", lastname: "Doe", email: "j@doe.com", password_reset_token: "test-token"}
    changeset = Accounts.change_user_password(user)
    content   = render_to_string(PasswordView, "edit.html",
                                 conn: conn, token: user.password_reset_token, changeset: changeset)

    assert String.contains?(content, "Enter a new password")
  end
end

