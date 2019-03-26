defmodule PtrWeb.OwnerController do
  use PtrWeb, :controller

  alias Ptr.Ownerships
  alias Ptr.Ownerships.Owner

  plug(:authenticate)
  plug(:put_breadcrumb, name: dgettext("owners", "Owners"), url: "/owners")

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Ownerships.list_owners(session.account, params)

    render_index(conn, page)
  end

  def new(conn, _params, session) do
    changeset = Ownerships.change_owner(session.account, %Owner{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"owner" => owner_params}, session) do
    case Ownerships.create_owner(session, owner_params) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, dgettext("owners", "Owner created successfully."))
        |> redirect(to: Routes.owner_path(conn, :show, owner))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session) do
    owner = Ownerships.get_owner!(session.account, id)

    conn
    |> put_show_breadcrumb(owner)
    |> render("show.html", owner: owner)
  end

  def edit(conn, %{"id" => id}, session) do
    owner = Ownerships.get_owner!(session.account, id)
    changeset = Ownerships.change_owner(session.account, owner)

    conn
    |> put_edit_breadcrumb(owner)
    |> render("edit.html", owner: owner, changeset: changeset)
  end

  def update(conn, %{"id" => id, "owner" => owner_params}, session) do
    owner = Ownerships.get_owner!(session.account, id)

    case Ownerships.update_owner(session, owner, owner_params) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, dgettext("owners", "Owner updated successfully."))
        |> redirect(to: Routes.owner_path(conn, :show, owner))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", owner: owner, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    owner = Ownerships.get_owner!(session.account, id)
    {:ok, _owner} = Ownerships.delete_owner(session, owner)

    conn
    |> put_flash(:info, dgettext("owners", "Owner deleted successfully."))
    |> redirect(to: Routes.owner_path(conn, :index))
  end

  defp render_index(conn, %{total_entries: 0}), do: render(conn, "empty.html")

  defp render_index(conn, page) do
    render(conn, "index.html", owners: page.entries, page: page)
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("owners", "New owner")
    url = Routes.owner_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, owner) do
    name = dgettext("owners", "Owner")
    url = Routes.owner_path(conn, :show, owner)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, owner) do
    name = dgettext("owners", "Edit owner")
    url = Routes.owner_path(conn, :edit, owner)

    conn |> put_breadcrumb(name, url)
  end
end
