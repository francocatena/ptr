defmodule PtrWeb.LayoutView do
  use PtrWeb, :view

  import Phoenix.Controller, only: [get_flash: 1]

  def locale do
    PtrWeb.Gettext
    |> Gettext.get_locale()
    |> String.replace(~r/_\w+/, "")
  end

  def render_flash(conn) do
    case get_flash_message(conn) do
      {type, message} ->
        render("_flash.html", conn: conn, type: type, message: message)
      nil ->
        ""
    end
  end

  def flash_class("info"),  do: "is-info"
  def flash_class("error"), do: "is-danger"

  defp get_flash_message(conn) do
    conn
    |> get_flash
    |> Enum.at(0)
  end
end
