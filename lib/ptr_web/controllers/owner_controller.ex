defmodule PtrWeb.OwnerController do
  use PtrWeb, :controller

  alias Ptr.Ownerships
  alias Ptr.Ownerships.Owner

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("owners", "Owners"), url: "/owners"

  def index(%{assigns: %{current_session: session}} = conn, params) do
    page = Ownerships.list_owners(session.account, params)

    render(conn, "index.html", owners: page.entries, page: page)
  end

  def new(%{assigns: %{current_session: session}} = conn, _params) do
    changeset = Ownerships.change_owner(session.account, %Owner{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_session: session}} = conn, %{"owner" => owner_params}) do
    case Ownerships.create_owner(session, owner_params) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, dgettext("owners", "Owner created successfully."))
        |> redirect(to: owner_path(conn, :show, owner))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    owner = Ownerships.get_owner!(session.account, id)

    conn
    |> put_show_breadcrumb(owner)
    |> render("show.html", owner: owner)
  end

  def edit(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    owner     = Ownerships.get_owner!(session.account, id)
    changeset = Ownerships.change_owner(session.account, owner)

    conn
    |> put_edit_breadcrumb(owner)
    |> render("edit.html", owner: owner, changeset: changeset)
  end

  def update(%{assigns: %{current_session: session}} = conn, %{"id" => id, "owner" => owner_params}) do
    owner = Ownerships.get_owner!(session.account, id)

    case Ownerships.update_owner(session, owner, owner_params) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, dgettext("owners", "Owner updated successfully."))
        |> redirect(to: owner_path(conn, :show, owner))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", owner: owner, changeset: changeset)
    end
  end

  def delete(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    owner = Ownerships.get_owner!(session.account, id)
    {:ok, _owner} = Ownerships.delete_owner(session, owner)

    conn
    |> put_flash(:info, dgettext("owners", "Owner deleted successfully."))
    |> redirect(to: owner_path(conn, :index))
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("owners", "New owner")
    url  = owner_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, owner) do
    name = dgettext("owners", "Owner")
    url  = owner_path(conn, :show, owner)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, owner) do
    name = dgettext("owners", "Edit owner")
    url  = owner_path(conn, :edit, owner)

    conn |> put_breadcrumb(name, url)
  end
end
