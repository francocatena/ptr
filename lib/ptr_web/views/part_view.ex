defmodule PtrWeb.PartView do
  use PtrWeb, :view
  use Scrivener.HTML

  def link_to_show(conn, lot, part) do
    icon_link(
      "eye",
      title: dgettext("parts", "Show"),
      to: Routes.lot_part_path(conn, :show, lot, part),
      class: "button is-small is-outlined is-hidden-mobile",
      data: [target: "link.link"]
    )
  end

  def link_to_edit(conn, lot, part) do
    icon_link(
      "pencil-alt",
      title: dgettext("parts", "Edit"),
      to: Routes.lot_part_path(conn, :edit, lot, part),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, lot, part) do
    icon_link(
      "trash",
      title: dgettext("parts", "Delete"),
      to: Routes.lot_part_path(conn, :delete, lot, part),
      method: :delete,
      data: [confirm: dgettext("parts", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, part) do
    hidden_input(form, :lock_version, value: part.lock_version)
  end

  def submit_button(part) do
    submit_label(part)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  def vessels(account, cellar) do
    account
    |> Ptr.Cellars.list_vessels(cellar)
    |> Enum.map(&[key: &1.identifier, value: &1.id])
  end

  defp submit_label(nil), do: dgettext("parts", "Create")
  defp submit_label(_), do: dgettext("parts", "Update")
end
