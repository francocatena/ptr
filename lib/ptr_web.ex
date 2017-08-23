defmodule PtrWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use PtrWeb, :controller
      use PtrWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: PtrWeb
      import Plug.Conn
      import PtrWeb.Router.Helpers
      import PtrWeb.Gettext
      import PtrWeb.BreadcrumbPlug, only: [put_breadcrumb: 2, put_breadcrumb: 3]
      import PtrWeb.SessionPlug, only: [authenticate: 2]
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/ptr_web/templates",
                        namespace: PtrWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PtrWeb.Router.Helpers
      import PtrWeb.ErrorHelpers
      import PtrWeb.InputHelpers
      import PtrWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import PtrWeb.BreadcrumbPlug, only: [put_breadcrumb: 2]
      import PtrWeb.SessionPlug, only: [fetch_current_account: 2, fetch_current_user: 2]
      import PtrWeb.CacheControlPlug, only: [put_cache_control_headers: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import PtrWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
