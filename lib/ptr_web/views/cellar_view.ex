defmodule PtrWeb.CellarView do
  use PtrWeb, :view
  use Scrivener.HTML

  import Ptr.Cellars, only: [cellar_vessel_count: 2]

  def link_to_show(conn, cellar) do
    icon_link "eye",
      title: dgettext("cellars", "Show"),
      to:    cellar_path(conn, :show, cellar),
      class: "button is-small is-outlined is-hidden-mobile",
      data:  [main_link: true]
  end

  def link_to_edit(conn, cellar) do
    icon_link "pencil-alt",
      title: dgettext("cellars", "Edit"),
      to:    cellar_path(conn, :edit, cellar),
      class: "button is-small is-outlined is-hidden-mobile"
  end

  def link_to_delete(conn, cellar) do
    icon_link "trash",
      title:  dgettext("cellars", "Delete"),
      to:     cellar_path(conn, :delete, cellar),
      method: :delete,
      data:   [confirm: dgettext("cellars", "Are you sure?")],
      class:  "button is-small is-danger is-outlined"
  end

  def lock_version_input(_, nil), do: nil
  def lock_version_input(form, cellar) do
    hidden_input form, :lock_version, [value: cellar.lock_version]
  end

  def submit_button(cellar) do
    submit_label(cellar)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  def render_vessels(conn, account, cellar) do
    case cellar_vessel_count(account, cellar) do
      0     -> render("_empty_vessels.html", conn: conn, cellar: cellar)
      count -> render("_vessels.html", conn: conn, cellar: cellar, count: count)
    end
  end

  defp submit_label(nil), do: dgettext("cellars", "Create")
  defp submit_label(_),   do: dgettext("cellars", "Update")
end
