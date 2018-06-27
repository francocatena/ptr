defmodule PtrWeb.Router do
  use PtrWeb, :router

  @csp [
    "default-src 'self'",
    "script-src 'self' 'unsafe-inline'",
    "style-src 'self' 'unsafe-inline'"
  ]

  @csp_headers %{"content-security-policy" => Enum.join(@csp, ";")}

  pipeline :browser do
    plug(:accepts, ["html", "js"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_current_session)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers, @csp_headers)
    plug(:put_cache_control_headers)
    plug(:put_breadcrumb, name: "≡", url: "/")
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
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

    # Options

    resources("/varieties", VarietyController)

    # Ownerships

    resources("/owners", OwnerController)

    # Cellars

    resources "/cellars", CellarController do
      resources("/vessels", VesselController)
    end

    # Lots

    resources("/lots", LotController) do
      resources("/parts", PartController)
    end
  end
end
