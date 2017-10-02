defmodule PtrWeb.CellarController do
  use PtrWeb, :controller

  alias Ptr.Cellars
  alias Ptr.Cellars.Cellar

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("cellars", "Cellars"), url: "/cellars"

  def index(%{assigns: %{current_session: session}} = conn, params) do
    page = Cellars.list_cellars(session.account, params)

    render_index(conn, page)
  end

  def new(%{assigns: %{current_session: session}} = conn, _params) do
    changeset = Cellars.change_cellar(session.account, %Cellar{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_session: session}} = conn, %{"cellar" => cellar_params}) do
    case Cellars.create_cellar(session, cellar_params) do
      {:ok, cellar} ->
        conn
        |> put_flash(:info, dgettext("cellars", "Cellar created successfully."))
        |> redirect(to: cellar_path(conn, :show, cellar))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    cellar = Cellars.get_cellar!(session.account, id)

    conn
    |> put_show_breadcrumb(cellar)
    |> render("show.html", cellar: cellar)
  end

  def edit(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    cellar = Cellars.get_cellar!(session.account, id)
    changeset = Cellars.change_cellar(session.account, cellar)

    conn
    |> put_edit_breadcrumb(cellar)
    |> render("edit.html", cellar: cellar, changeset: changeset)
  end

  def update(%{assigns: %{current_session: session}} = conn, %{"id" => id, "cellar" => cellar_params}) do
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

  def delete(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
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
    name = dgettext("cellars", "Cellar")
    url  = cellar_path(conn, :show, cellar)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, cellar) do
    name = dgettext("cellars", "Edit cellar")
    url  = cellar_path(conn, :edit, cellar)

    conn |> put_breadcrumb(name, url)
  end
end
