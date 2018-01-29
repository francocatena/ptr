defmodule PtrWeb.PasswordControllerTest do
  use PtrWeb.ConnCase

  import Ptr.Support.FixtureHelper

  alias Ptr.Accounts.User
  alias Ptr.Repo

  describe "new password" do
    test "renders new", %{conn: conn} do
      conn = get(conn, password_path(conn, :new))

      assert html_response(conn, 200) =~ ~r/Forgot your password/
    end
  end

  describe "create password" do
    alias Ptr.Notifications.Email
    use Bamboo.Test

    test "sends instructions when email exist", %{conn: conn} do
      {:ok, user, _} = fixture(:user)
      conn = post(conn, password_path(conn, :create), user: %{email: user.email})

      assert redirected_to(conn) == root_path(conn, :index)

      user = Repo.get(User, user.id)

      assert_delivered_email(Email.password_reset(user))
    end

    test "renders errors when email does not exist", %{conn: conn} do
      conn = post(conn, password_path(conn, :create), user: %{email: "wrong"})

      assert html_response(conn, 200)
      assert get_flash(conn, :error) =~ ~r/Email not found/
    end
  end

  describe "edit password" do
    test "renders edit when valid token", %{conn: conn} do
      user = user_with_password_reset_token()
      conn = get(conn, password_path(conn, :edit, user.password_reset_token))

      assert html_response(conn, 200) =~ ~r/Enter a new password/
    end

    test "redirects when invalid token", %{conn: conn} do
      conn = get(conn, password_path(conn, :edit, "invalid-token"))

      assert redirected_to(conn) == root_path(conn, :index)
    end
  end

  describe "update password" do
    @valid_attrs %{password: "newpass", password_confirmation: "newpass"}
    @invalid_attrs %{password: "newpass", password_confirmation: "wrong"}

    test "redirects when data is valid", %{conn: conn} do
      user = user_with_password_reset_token()

      conn =
        put(conn, password_path(conn, :update, user.password_reset_token), user: @valid_attrs)

      assert redirected_to(conn) == root_path(conn, :index)

      user = Repo.get(User, user.id)

      assert Comeonin.Argon2.checkpw(@valid_attrs.password, user.password_hash)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_with_password_reset_token()

      conn =
        put(conn, password_path(conn, :update, user.password_reset_token), user: @invalid_attrs)

      assert html_response(conn, 200)

      user = Repo.get(User, user.id)

      refute Comeonin.Argon2.checkpw(@invalid_attrs.password, user.password_hash)
    end

    test "redirects when invalid token", %{conn: conn} do
      conn = put(conn, password_path(conn, :update, "invalid-token"), user: @valid_attrs)

      assert redirected_to(conn) == root_path(conn, :index)
    end
  end

  defp user_with_password_reset_token do
    {:ok, user, _} = fixture(:user)

    user
    |> User.password_reset_token_changeset()
    |> Repo.update!()
  end
end
