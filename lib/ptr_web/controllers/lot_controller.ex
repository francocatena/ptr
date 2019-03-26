defmodule PtrWeb.LotController do
  use PtrWeb, :controller

  alias Ptr.Lots
  alias Ptr.Lots.Lot

  plug(:authenticate)
  plug(:put_breadcrumb, name: dgettext("lots", "Lots"), url: "/lots")

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Lots.list_lots(session.account, params)

    render_index(conn, page)
  end

  def new(conn, _params, session) do
    changeset = Lots.change_lot(session.account, %Lot{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset, account: session.account)
  end

  def create(conn, %{"lot" => lot_params}, session) do
    case Lots.create_lot(session, lot_params) do
      {:ok, lot} ->
        conn
        |> put_flash(:info, dgettext("lots", "Lot created successfully."))
        |> redirect(to: Routes.lot_path(conn, :show, lot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, account: session.account)
    end
  end

  def show(conn, %{"id" => id}, session) do
    lot = Lots.get_lot!(session.account, id)

    conn
    |> put_show_breadcrumb(lot)
    |> render("show.html", lot: lot)
  end

  def edit(conn, %{"id" => id}, session) do
    lot = Lots.get_lot!(session.account, id)
    changeset = Lots.change_lot(session.account, lot)

    conn
    |> put_edit_breadcrumb(lot)
    |> render("edit.html", lot: lot, changeset: changeset, account: session.account)
  end

  def update(conn, %{"id" => id, "lot" => lot_params}, session) do
    lot = Lots.get_lot!(session.account, id)

    case Lots.update_lot(session, lot, lot_params) do
      {:ok, lot} ->
        conn
        |> put_flash(:info, dgettext("lots", "Lot updated successfully."))
        |> redirect(to: Routes.lot_path(conn, :show, lot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", lot: lot, changeset: changeset, account: session.account)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    lot = Lots.get_lot!(session.account, id)
    {:ok, _lot} = Lots.delete_lot(session, lot)

    conn
    |> put_flash(:info, dgettext("lots", "Lot deleted successfully."))
    |> redirect(to: Routes.lot_path(conn, :index))
  end

  defp render_index(conn, %{total_entries: 0}), do: render(conn, "empty.html")

  defp render_index(conn, page) do
    render(conn, "index.html", lots: page.entries, page: page)
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("lots", "New lot")
    url = Routes.lot_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, lot) do
    name = dgettext("lots", "Lot")
    url = Routes.lot_path(conn, :show, lot)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, lot) do
    name = dgettext("lots", "Edit lot")
    url = Routes.lot_path(conn, :edit, lot)

    conn |> put_breadcrumb(name, url)
  end
end
