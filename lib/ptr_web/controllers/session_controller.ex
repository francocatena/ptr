defmodule PtrWeb.SessionController do
  use PtrWeb, :controller

  plug :authenticate when action in [:delete]

  def new(%{assigns: %{current_account: account}} = conn, _params)
  when is_map(account) do
    redirect(conn, to: root_path(conn, :index))
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Ptr.Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Welcome!"))
        |> put_session(:user_id, user.id)
        |> put_session(:account_id, user.account_id)
        |> configure_session(renew: true)
        |> redirect(to: root_path(conn, :index))
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, gettext("Invalid email/password combination"))
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> clear_session()
    |> put_flash(:info, gettext("See you soon!"))
    |> redirect(to: root_path(conn, :index))
  end
end
