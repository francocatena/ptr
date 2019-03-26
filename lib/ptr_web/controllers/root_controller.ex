defmodule PtrWeb.RootController do
  use PtrWeb, :controller

  def index(%{assigns: %{current_session: session}} = conn, _params)
      when is_map(session) do
    redirect(conn, to: Routes.cellar_path(conn, :index))
  end

  def index(conn, _params) do
    redirect(conn, to: Routes.session_path(conn, :new))
  end
end
