defmodule PtrWeb.OwnerView do
  use PtrWeb, :view
  use Scrivener.HTML

  alias Ptr.Ownerships.Owner

  def link_to_show(conn, owner) do
    icon_link(
      "eye",
      title: dgettext("owners", "Show"),
      to: Routes.owner_path(conn, :show, owner),
      class: "button is-small is-outlined is-hidden-mobile",
      data: [target: "link.link"]
    )
  end

  def link_to_edit(conn, owner) do
    icon_link(
      "pen",
      title: dgettext("owners", "Edit"),
      to: Routes.owner_path(conn, :edit, owner),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, %Owner{lots_count: 0} = owner) do
    icon_link(
      "trash",
      title: dgettext("owners", "Delete"),
      to: Routes.owner_path(conn, :delete, owner),
      method: :delete,
      data: [confirm: dgettext("owners", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def link_to_delete(_conn, _owner), do: nil

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, owner) do
    hidden_input(form, :lock_version, value: owner.lock_version)
  end

  def submit_button(owner) do
    owner
    |> submit_label()
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  defp submit_label(nil), do: dgettext("owners", "Create")
  defp submit_label(_), do: dgettext("owners", "Update")
end
