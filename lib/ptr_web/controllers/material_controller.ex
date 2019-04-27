defmodule PtrWeb.MaterialController do
  use PtrWeb, :controller

  alias Ptr.Options
  alias Ptr.Options.Material

  plug(:authenticate)
  plug(:put_breadcrumb, name: dgettext("materials", "Materials"), url: "/materials")

  def action(%{assigns: %{current_session: session}} = conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    page = Options.list_materials(session.account, params)

    render_index(conn, page)
  end

  def new(conn, _params, session) do
    changeset = Options.change_material(session.account, %Material{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"material" => material_params}, session) do
    case Options.create_material(session, material_params) do
      {:ok, material} ->
        conn
        |> put_flash(:info, dgettext("materials", "Material created successfully."))
        |> redirect(to: Routes.material_path(conn, :show, material))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, session) do
    material = Options.get_material!(session.account, id)

    conn
    |> put_show_breadcrumb(material)
    |> render("show.html", material: material)
  end

  def edit(conn, %{"id" => id}, session) do
    material = Options.get_material!(session.account, id)
    changeset = Options.change_material(session.account, material)

    conn
    |> put_edit_breadcrumb(material)
    |> render("edit.html", material: material, changeset: changeset)
  end

  def update(conn, %{"id" => id, "material" => material_params}, session) do
    material = Options.get_material!(session.account, id)

    case Options.update_material(session, material, material_params) do
      {:ok, material} ->
        conn
        |> put_flash(:info, dgettext("materials", "Material updated successfully."))
        |> redirect(to: Routes.material_path(conn, :show, material))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", material: material, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    material = Options.get_material!(session.account, id)
    {:ok, _material} = Options.delete_material(session, material)

    conn
    |> put_flash(:info, dgettext("materials", "Material deleted successfully."))
    |> redirect(to: Routes.material_path(conn, :index))
  end

  defp render_index(conn, %{total_entries: 0}), do: render(conn, "empty.html")

  defp render_index(conn, page) do
    render(conn, "index.html", materials: page.entries, page: page)
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("materials", "New material")
    url = Routes.material_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, material) do
    name = dgettext("materials", "Material")
    url = Routes.material_path(conn, :show, material)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, material) do
    name = dgettext("materials", "Edit material")
    url = Routes.material_path(conn, :edit, material)

    conn |> put_breadcrumb(name, url)
  end
end
