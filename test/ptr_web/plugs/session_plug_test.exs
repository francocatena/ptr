defmodule PtrWeb.SessionPlugTest do
  use PtrWeb.ConnCase

  import Ptr.Support.FixtureHelper

  alias PtrWeb.SessionPlug

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(PtrWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  describe "fetch current user" do
    test "fetch current user from session", %{conn: conn} do
      user = fixture(:user)

      refute conn.assigns.current_user

      login_conn =
        conn
        |> put_session(:account_id, user.account_id)
        |> put_session(:user_id, user.id)
        |> SessionPlug.fetch_current_user([])
        |> send_resp(:ok, "")

      next_conn = get(login_conn, "/")

      assert get_session(next_conn, :user_id) == user.id
    end

    test "fetch continues when current_user exists", %{conn: conn} do
      refute conn.assigns.current_user

      conn =
        conn
        |> assign(:current_user, %Ptr.Accounts.User{})
        |> SessionPlug.fetch_current_user([])

      assert conn.assigns.current_user
    end

    test "fetch no user if no user_id on session and not set on assigns", %{conn: conn} do
      conn = SessionPlug.fetch_current_user(conn, [])

      refute conn.assigns.current_user
    end
  end

  describe "fetch current account" do
    test "fetch current account from session", %{conn: conn} do
      account = fixture(:account)

      refute conn.assigns.current_account

      login_conn =
        conn
        |> put_session(:account_id, account.id)
        |> SessionPlug.fetch_current_account([])
        |> send_resp(:ok, "")

      next_conn = get(login_conn, "/")

      assert get_session(next_conn, :account_id) == account.id
    end

    test "fetch continues when current_account exists", %{conn: conn} do
      refute conn.assigns.current_account

      conn =
        conn
        |> assign(:current_account, %Ptr.Accounts.Account{})
        |> SessionPlug.fetch_current_account([])

      assert conn.assigns.current_account
    end

    test "fetch no account if no account_id on session and not set on assigns", %{conn: conn} do
      conn = SessionPlug.fetch_current_account(conn, [])

      refute conn.assigns.current_account
    end
  end

  describe "authentication" do
    test "authenticate halts when no current_user exists", %{conn: conn} do
      refute conn.halted

      conn = SessionPlug.authenticate(conn, [])

      assert conn.halted
      refute get_session(conn, :previous_url)
    end

    test "authenticate continues when the current_user exists", %{conn: conn} do
      conn =
        conn
        |> assign(:current_user, %Ptr.Accounts.User{})
        |> SessionPlug.authenticate([])

      refute conn.halted
    end

    test "authenticate stores request path when no current_user exists", %{conn: conn} do
      refute conn.halted

      conn = SessionPlug.authenticate(%{conn | request_path: "/test"}, [])

      assert conn.halted
      assert get_session(conn, :previous_url) == "/test"
    end
  end
end
