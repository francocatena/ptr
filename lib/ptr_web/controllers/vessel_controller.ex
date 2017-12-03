defmodule PtrWeb.VesselController do
  use PtrWeb, :controller

  alias Ptr.Cellars
  alias Ptr.Cellars.Vessel

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("cellars", "Cellars"), url: "/cellars"

  def action(%{assigns: %{current_session: session}} = conn, _) do
    cellar = Cellars.get_cellar!(session.account, conn.params["cellar_id"])
    name   = dgettext("vessels", "Vessels")

    url    = cellar_path(conn, :show, cellar)
    conn   = put_breadcrumb(conn, name: cellar.name, url: url)

    url    = cellar_vessel_path(conn, :index, cellar)
    conn   = put_breadcrumb(conn, name: name, url: url)

    apply(__MODULE__, action_name(conn), [conn, conn.params, cellar])
  end

  def index(%{assigns: %{current_session: session}} = conn, params, cellar) do
    page = Cellars.list_vessels(session.account, cellar, params)

    render_index(conn, page, cellar: cellar)
  end

  def new(%{assigns: %{current_session: session}} = conn, _params, cellar) do
    vessel    = %Vessel{cellar_id: cellar.id}
    changeset = Cellars.change_vessel(session.account, vessel)

    conn
    |> put_new_breadcrumb(cellar)
    |> render("new.html", changeset: changeset, cellar: cellar)
  end

  def create(%{assigns: %{current_session: session}} = conn, %{"vessel" => vessel_params}, cellar) do
    vessel_params = Map.put(vessel_params, "cellar_id", cellar.id)

    case Cellars.create_vessel(session, vessel_params) do
      {:ok, vessel} ->
        conn
        |> put_flash(:info, dgettext("vessels", "Vessel created successfully."))
        |> redirect(to: cellar_vessel_path(conn, :show, cellar, vessel))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, cellar: cellar)
    end
  end

  def show(%{assigns: %{current_session: session}} = conn, %{"id" => id}, cellar) do
    vessel = Cellars.get_vessel!(session.account, cellar, id)

    conn
    |> put_show_breadcrumb(vessel, cellar)
    |> render("show.html", vessel: vessel, cellar: cellar)
  end

  def edit(%{assigns: %{current_session: session}} = conn, %{"id" => id}, cellar) do
    vessel = Cellars.get_vessel!(session.account, cellar, id)
    changeset = Cellars.change_vessel(session.account, vessel)

    conn
    |> put_edit_breadcrumb(vessel, cellar)
    |> render("edit.html", vessel: vessel, changeset: changeset, cellar: cellar)
  end

  def update(%{assigns: %{current_session: session}} = conn, %{"id" => id, "vessel" => vessel_params}, cellar) do
    vessel = Cellars.get_vessel!(session.account, cellar, id)

    case Cellars.update_vessel(session, vessel, vessel_params) do
      {:ok, vessel} ->
        conn
        |> put_flash(:info, dgettext("vessels", "Vessel updated successfully."))
        |> redirect(to: cellar_vessel_path(conn, :show, cellar, vessel))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", vessel: vessel, changeset: changeset, cellar: cellar)
    end
  end

  def delete(%{assigns: %{current_session: session}} = conn, %{"id" => id}, cellar) do
    vessel = Cellars.get_vessel!(session.account, cellar, id)
    {:ok, _vessel} = Cellars.delete_vessel(session, vessel)

    conn
    |> put_flash(:info, dgettext("vessels", "Vessel deleted successfully."))
    |> redirect(to: cellar_vessel_path(conn, :index, cellar))
  end

  defp render_index(conn, %{total_entries: 0}, opts) do
    render(conn, "empty.html", opts)
  end

  defp render_index(conn, page, opts) do
    opts =
      opts
      |> Keyword.put(:vessels, page.entries)
      |> Keyword.put(:page, page)

    render(conn, "index.html", opts)
  end

  defp put_new_breadcrumb(conn, cellar) do
    name = dgettext("vessels", "New vessel")
    url  = cellar_vessel_path(conn, :new, cellar)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, vessel, cellar) do
    name = vessel.identifier
    url  = cellar_vessel_path(conn, :show, cellar, vessel)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, vessel, cellar) do
    name = dgettext("vessels", "Edit vessel")
    url  = cellar_vessel_path(conn, :edit, cellar, vessel)

    conn |> put_breadcrumb(name, url)
  end
end
