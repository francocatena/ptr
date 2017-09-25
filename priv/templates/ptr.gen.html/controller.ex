defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Controller do
  use <%= inspect context.web_module %>, :controller

  alias <%= inspect context.module %>
  alias <%= inspect schema.module %>

  plug :authenticate
  plug :put_breadcrumb, name: dgettext("<%= schema.plural %>", "<%= schema.human_plural %>"), url: "/<%= schema.plural %>"

  def index(%{assigns: %{current_session: session}} = conn, params) do
    page = <%= inspect context.alias %>.list_<%= schema.plural %>(session.account, params)

    render(conn, "index.html", <%= schema.plural %>: page.entries, page: page)
  end

  def new(%{assigns: %{current_session: _}} = conn, _params) do
    changeset = <%= inspect context.alias %>.change_<%= schema.singular %>(%<%= inspect schema.alias %>{})

    conn
    |> put_new_breadcrumb
    |> render("new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_session: session}} = conn, %{<%= inspect schema.singular %> => <%= schema.singular %>_params}) do
    case <%= inspect context.alias %>.create_<%= schema.singular %>(session, <%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        conn
        |> put_flash(:info, dgettext("<%= schema.plural %>", "<%= schema.human_singular %> created successfully."))
        |> redirect(to: <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(session.account, id)

    conn
    |> put_show_breadcrumb(<%= schema.singular %>)
    |> render("show.html", <%= schema.singular %>: <%= schema.singular %>)
  end

  def edit(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(session.account, id)
    changeset = <%= inspect context.alias %>.change_<%= schema.singular %>(<%= schema.singular %>)

    conn
    |> put_edit_breadcrumb(<%= schema.singular %>)
    |> render("edit.html", <%= schema.singular %>: <%= schema.singular %>, changeset: changeset)
  end

  def update(%{assigns: %{current_session: session}} = conn, %{"id" => id, <%= inspect schema.singular %> => <%= schema.singular %>_params}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(session.account, id)

    case <%= inspect context.alias %>.update_<%= schema.singular %>(session, <%= schema.singular %>, <%= schema.singular %>_params) do
      {:ok, <%= schema.singular %>} ->
        conn
        |> put_flash(:info, dgettext("<%= schema.plural %>", "<%= schema.human_singular %> updated successfully."))
        |> redirect(to: <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", <%= schema.singular %>: <%= schema.singular %>, changeset: changeset)
    end
  end

  def delete(%{assigns: %{current_session: session}} = conn, %{"id" => id}) do
    <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>!(session.account, id)
    {:ok, _<%= schema.singular %>} = <%= inspect context.alias %>.delete_<%= schema.singular %>(session, <%= schema.singular %>)

    conn
    |> put_flash(:info, dgettext("<%= schema.plural %>", "<%= schema.human_singular %> deleted successfully."))
    |> redirect(to: <%= schema.route_helper %>_path(conn, :index))
  end

  defp put_new_breadcrumb(conn) do
    name = dgettext("<%= schema.plural %>", "New <%= schema.singular %>")
    url  = <%= schema.route_helper %>_path(conn, :new)

    conn |> put_breadcrumb(name, url)
  end

  defp put_show_breadcrumb(conn, <%= schema.singular %>) do
    name = dgettext("<%= schema.plural %>", "<%= schema.human_singular%>")
    url  = <%= schema.route_helper %>_path(conn, :show, <%= schema.singular %>)

    conn |> put_breadcrumb(name, url)
  end

  defp put_edit_breadcrumb(conn, <%= schema.singular %>) do
    name = dgettext("<%= schema.plural %>", "Edit <%= schema.singular %>")
    url  = <%= schema.route_helper %>_path(conn, :edit, <%= schema.singular %>)

    conn |> put_breadcrumb(name, url)
  end
end
