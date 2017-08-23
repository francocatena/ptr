defmodule PtrWeb.SessionPlug do
  import Phoenix.Controller
  import Plug.Conn
  import PtrWeb.Gettext

  alias Ptr.Accounts
  alias PtrWeb.Router.Helpers

  def fetch_current_account(%{assigns: %{current_account: account}} = conn, _opts)
  when is_map(account),
    do: conn

  def fetch_current_account(conn, _opts) do
    account_id = get_session(conn, :account_id)
    account    = account_id && Accounts.get_account!(account_id)

    assign(conn, :current_account, account)
  end

  def fetch_current_user(%{assigns: %{current_user: user}} = conn, _opts)
  when is_map(user),
    do: conn

  def fetch_current_user(conn, _opts) do
    account_id = get_session(conn, :account_id)
    user_id    = get_session(conn, :user_id)
    user       = user_id && Accounts.get_user!(user_id, account_id)

    assign(conn, :current_user, user)
  end

  def authenticate(%{assigns: %{current_user: user}} = conn, _opts)
  when is_map(user),
    do: conn

  def authenticate(conn, _opts) do
    conn
    |> put_flash(:error, dgettext("sessions", "You must be logged in."))
    |> redirect(to: Helpers.session_path(conn, :new))
    |> halt()
  end
end
