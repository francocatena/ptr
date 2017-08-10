defmodule PtrWeb.UserController do
  use PtrWeb, :controller

  alias Ptr.Accounts
  alias Ptr.Accounts.User

  plug :authenticate
  plug :put_breadcrumb, name: gettext("Users"), url: "/users"

  def index(%{assigns: %{current_account: account}} = conn, _params) do
    users = Accounts.list_users(account.id)

    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
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

    conn
    |> put_show_breadcrumb(user)
    |> render("show.html", user: user)
  end

  def edit(%{assigns: %{current_account: account}} = conn, %{"id" => id}) do
    user = Accounts.get_user!(id, account.id)
    changeset = Accounts.change_user(user)

    conn
    |> put_edit_breadcrumb(user)
    |> render("edit.html", user: user, changeset: changeset)
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

  defp put_new_breadcrumb(conn) do
    put_breadcrumb(conn, name: gettext("New user"), url: user_path(conn, :new), active: true)
  end

  defp put_show_breadcrumb(conn, user) do
    put_breadcrumb(conn, name: user.email, url: user_path(conn, :show, user), active: true)
  end

  defp put_edit_breadcrumb(conn, user) do
    put_breadcrumb(conn, name: gettext("Edit user"), url: user_path(conn, :edit, user), active: true)
  end
end
