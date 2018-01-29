defmodule PtrWeb.Router do
  use PtrWeb, :router

  pipeline :browser do
    plug(:accepts, ["html", "js"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_current_session)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_cache_control_headers)
    plug(:put_breadcrumb, name: "≡", url: "/")
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.EmailPreviewPlug)
  end

  scope "/", PtrWeb do
    pipe_through(:browser)

    get("/", RootController, :index)

    resources(
      "/sessions",
      SessionController,
      only: [:new, :create, :delete],
      singleton: true
    )

    # Accounts

    resources("/passwords", PasswordController, only: [:new, :create, :edit, :update])

    resources("/users", UserController)

    # Ownerships

    resources("/owners", OwnerController)

    # Cellars

    resources "/cellars", CellarController do
      resources("/vessels", VesselController)
    end
  end
end
