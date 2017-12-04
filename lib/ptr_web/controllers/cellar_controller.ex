defmodule PtrWeb.CellarController do
  use PtrWeb, :controller

  alias Ptr.Cellars
  alias Ptr.Cellars.Cellar

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("cellars", "Cellars"), url: "/cellars"

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Cellars.list_cellars(session.account, params)

    render_index(conn, page)
  end

  def new(conn, _params, session) do
    changeset = Cellars.change_cellar(session.account, %Cellar{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"cellar" => cellar_params}, session) do
    case Cellars.create_cellar(session, cellar_params) do
      {:ok, cellar} ->
        conn
        |> put_flash(:info, dgettext("cellars", "Cellar created successfully."))
        |> redirect(to: cellar_path(conn, :show, cellar))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session) do
    cellar = Cellars.get_cellar!(session.account, id)

    conn
    |> put_show_breadcrumb(cellar)
    |> render("show.html", cellar: cellar)
  end

  def edit(conn, %{"id" => id}, session) do
    cellar = Cellars.get_cellar!(session.account, id)
    changeset = Cellars.change_cellar(session.account, cellar)

    conn
    |> put_edit_breadcrumb(cellar)
    |> render("edit.html", cellar: cellar, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cellar" => cellar_params}, session) do
    cellar = Cellars.get_cellar!(session.account, id)

    case Cellars.update_cellar(session, cellar, cellar_params) do
      {:ok, cellar} ->
        conn
        |> put_flash(:info, dgettext("cellars", "Cellar updated successfully."))
        |> redirect(to: cellar_path(conn, :show, cellar))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", cellar: cellar, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    cellar = Cellars.get_cellar!(session.account, id)
    {:ok, _cellar} = Cellars.delete_cellar(session, cellar)

    conn
    |> put_flash(:info, dgettext("cellars", "Cellar deleted successfully."))
    |> redirect(to: cellar_path(conn, :index))
  end

  defp render_index(conn, %{total_entries: 0}), do: render(conn, "empty.html")
  defp render_index(conn, page) do
    render(conn, "index.html", cellars: page.entries, page: page)
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("cellars", "New cellar")
    url  = cellar_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, cellar) do
    url = cellar_path(conn, :show, cellar)

    conn |> put_breadcrumb(cellar.name, url)
  end

  defp put_edit_breadcrumb(conn, cellar) do
    name = dgettext("cellars", "Edit cellar")
    url  = cellar_path(conn, :edit, cellar)

    conn |> put_breadcrumb(name, url)
  end
end
