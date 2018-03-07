defmodule PtrWeb.LotView do
  use PtrWeb, :view
  use Scrivener.HTML

  def link_to_show(conn, lot) do
    icon_link(
      "eye",
      title: dgettext("lots", "Show"),
      to: lot_path(conn, :show, lot),
      class: "button is-small is-outlined is-hidden-mobile",
      data: [main_link: true]
    )
  end

  def link_to_edit(conn, lot) do
    icon_link(
      "pencil-alt",
      title: dgettext("lots", "Edit"),
      to: lot_path(conn, :edit, lot),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, lot) do
    icon_link(
      "trash",
      title: dgettext("lots", "Delete"),
      to: lot_path(conn, :delete, lot),
      method: :delete,
      data: [confirm: dgettext("lots", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, lot) do
    hidden_input(form, :lock_version, value: lot.lock_version)
  end

  def submit_button(lot) do
    submit_label(lot)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  def owners(account) do
    account
    |> Ptr.Ownerships.list_owners()
    |> Enum.map(&[key: &1.name, value: &1.id])
  end

  def varieties(account) do
    account
    |> Ptr.Options.list_varieties()
    |> Enum.map(&[key: &1.name, value: &1.id])
  end

  defp submit_label(nil), do: dgettext("lots", "Create")
  defp submit_label(_), do: dgettext("lots", "Update")
end
