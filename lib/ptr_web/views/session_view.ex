defmodule PtrWeb.SessionView do
  use PtrWeb, :view

  def email_input_html do
    [
      autofocus:    true,
      autocomplete: autocomplete_email(),
      class:        "input is-medium",
      placeholder:  dgettext("sessions", "Email")
    ]
  end

  defp autocomplete_email do
    case Mix.env() do
      "prod" -> "off"
      _      -> "on"
    end
  end
end
