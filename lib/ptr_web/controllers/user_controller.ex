defmodule PtrWeb.UserController do
  use PtrWeb, :controller

  alias Ptr.Accounts
  alias Ptr.Accounts.User

  plug :authenticate

  def index(%{assigns: %{current_account: account}} = conn, _params) do
    users = Accounts.list_users(account.id)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_account: account}} = conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params, account.id) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User created successfully."))
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{current_account: account}} = conn, %{"id" => id}) do
    user = Accounts.get_user!(id, account.id)
    render(conn, "show.html", user: user)
  end

  def edit(%{assigns: %{current_account: account}} = conn, %{"id" => id}) do
    user = Accounts.get_user!(id, account.id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%{assigns: %{current_account: account}} = conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id, account.id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(%{assigns: %{current_account: account}} = conn, %{"id" => id}) do
    user = Accounts.get_user!(id, account.id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, gettext("User deleted successfully."))
    |> redirect(to: user_path(conn, :index))
  end
end
