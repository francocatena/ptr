defmodule PtrWeb.VarietyController do
  use PtrWeb, :controller

  alias Ptr.Options
  alias Ptr.Options.Variety

  plug(:authenticate)
  plug(:put_breadcrumb, name: dgettext("varieties", "Varieties"), url: "/varieties")

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Options.list_varieties(session.account, params)

    render_index(conn, page)
  end

  def new(conn, _params, session) do
    changeset = Options.change_variety(session.account, %Variety{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"variety" => variety_params}, session) do
    case Options.create_variety(session, variety_params) do
      {:ok, variety} ->
        conn
        |> put_flash(:info, dgettext("varieties", "Variety created successfully."))
        |> redirect(to: Routes.variety_path(conn, :show, variety))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session) do
    variety = Options.get_variety!(session.account, id)

    conn
    |> put_show_breadcrumb(variety)
    |> render("show.html", variety: variety)
  end

  def edit(conn, %{"id" => id}, session) do
    variety = Options.get_variety!(session.account, id)
    changeset = Options.change_variety(session.account, variety)

    conn
    |> put_edit_breadcrumb(variety)
    |> render("edit.html", variety: variety, changeset: changeset)
  end

  def update(conn, %{"id" => id, "variety" => variety_params}, session) do
    variety = Options.get_variety!(session.account, id)

    case Options.update_variety(session, variety, variety_params) do
      {:ok, variety} ->
        conn
        |> put_flash(:info, dgettext("varieties", "Variety updated successfully."))
        |> redirect(to: Routes.variety_path(conn, :show, variety))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", variety: variety, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    variety = Options.get_variety!(session.account, id)
    {:ok, _variety} = Options.delete_variety(session, variety)

    conn
    |> put_flash(:info, dgettext("varieties", "Variety deleted successfully."))
    |> redirect(to: Routes.variety_path(conn, :index))
  end

  defp render_index(conn, %{total_entries: 0}), do: render(conn, "empty.html")

  defp render_index(conn, page) do
    render(conn, "index.html", varieties: page.entries, page: page)
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("varieties", "New variety")
    url = Routes.variety_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, variety) do
    name = dgettext("varieties", "Variety")
    url = Routes.variety_path(conn, :show, variety)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, variety) do
    name = dgettext("varieties", "Edit variety")
    url = Routes.variety_path(conn, :edit, variety)

    conn |> put_breadcrumb(name, url)
  end
end
