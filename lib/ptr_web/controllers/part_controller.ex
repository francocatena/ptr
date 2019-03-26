defmodule PtrWeb.PartController do
  use PtrWeb, :controller

  alias Ptr.Lots
  alias Ptr.Lots.Part

  plug(:authenticate)
  plug(:put_breadcrumb, name: dgettext("lots", "Lots"), url: "/lots")

  def action(%{assigns: %{current_session: session}} = conn, _) do
    lot = Lots.get_lot!(session.account, conn.params["lot_id"])
    name = dgettext("parts", "Parts")

    url = Routes.lot_path(conn, :show, lot)
    conn = put_breadcrumb(conn, name: lot.identifier, url: url)

    url = Routes.lot_part_path(conn, :index, lot)
    conn = put_breadcrumb(conn, name: name, url: url)

    apply(__MODULE__, action_name(conn), [conn, conn.params, session, lot])
  end

  def index(conn, params, session, lot) do
    page = Lots.list_parts(session.account, lot, params)

    render_index(conn, page, lot: lot)
  end

  def new(conn, _params, session, lot) do
    part = %Part{lot_id: lot.id}
    changeset = Lots.change_part(session.account, part)

    conn
    |> put_new_breadcrumb(lot)
    |> render("new.html", account: session.account, lot: lot, changeset: changeset)
  end

  def create(conn, %{"part" => part_params}, session, lot) do
    part_params = Map.put(part_params, "lot_id", lot.id)

    case Lots.create_part(session, part_params) do
      {:ok, part} ->
        conn
        |> put_flash(:info, dgettext("parts", "Part created successfully."))
        |> redirect(to: Routes.lot_part_path(conn, :show, lot, part))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", account: session.account, lot: lot, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session, lot) do
    part = Lots.get_part!(session.account, lot, id)

    conn
    |> put_show_breadcrumb(lot, part)
    |> render("show.html", lot: lot, part: part)
  end

  def edit(conn, %{"id" => id}, session, lot) do
    part = Lots.get_part!(session.account, lot, id)
    changeset = Lots.change_part(session.account, part)

    conn
    |> put_edit_breadcrumb(lot, part)
    |> render("edit.html", account: session.account, lot: lot, part: part, changeset: changeset)
  end

  def update(conn, %{"id" => id, "part" => part_params}, session, lot) do
    part = Lots.get_part!(session.account, lot, id)

    case Lots.update_part(session, part, part_params) do
      {:ok, part} ->
        conn
        |> put_flash(:info, dgettext("parts", "Part updated successfully."))
        |> redirect(to: Routes.lot_part_path(conn, :show, lot, part))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          account: session.account,
          lot: lot,
          part: part,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}, session, lot) do
    part = Lots.get_part!(session.account, lot, id)
    {:ok, _part} = Lots.delete_part(session, part)

    conn
    |> put_flash(:info, dgettext("parts", "Part deleted successfully."))
    |> redirect(to: Routes.lot_part_path(conn, :index, lot))
  end

  defp render_index(conn, %{total_entries: 0}, opts) do
    render(conn, "empty.html", opts)
  end

  defp render_index(conn, page, opts) do
    opts =
      opts
      |> Keyword.put(:parts, page.entries)
      |> Keyword.put(:page, page)

    render(conn, :index, opts)
  end

  defp put_new_breadcrumb(conn, lot) do
    name = dgettext("parts", "New part")
    url = Routes.lot_part_path(conn, :new, lot)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, lot, part) do
    name = dgettext("parts", "Part")
    url = Routes.lot_part_path(conn, :show, lot, part)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, lot, part) do
    name = dgettext("parts", "Edit part")
    url = Routes.lot_part_path(conn, :edit, lot, part)

    conn |> put_breadcrumb(name, url)
  end
end
