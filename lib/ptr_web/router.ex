defmodule PtrWeb.Router do
  use PtrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_current_account
    plug :fetch_current_user
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_cache_control_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PtrWeb do
    pipe_through :browser

    get "/", RootController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PtrWeb do
  #   pipe_through :api
  # end
end
