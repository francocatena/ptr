defmodule PtrWeb.MaterialView do
  use PtrWeb, :view
  use Scrivener.HTML

  alias Ptr.Options.Material

  def link_to_show(conn, material) do
    icon_link(
      "eye",
      title: dgettext("materials", "Show"),
      to: Routes.material_path(conn, :show, material),
      class: "button is-small is-outlined is-hidden-mobile",
      data: [target: "link.link"]
    )
  end

  def link_to_edit(conn, material) do
    icon_link(
      "pen",
      title: dgettext("materials", "Edit"),
      to: Routes.material_path(conn, :edit, material),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, %Material{vessels_count: 0} = material) do
    icon_link(
      "trash",
      title: dgettext("materials", "Delete"),
      to: Routes.material_path(conn, :delete, material),
      method: :delete,
      data: [confirm: dgettext("materials", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def link_to_delete(_conn, _material), do: nil

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, material) do
    hidden_input(form, :lock_version, value: material.lock_version)
  end

  def submit_button(material) do
    material
    |> submit_label()
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  defp submit_label(nil), do: dgettext("materials", "Create")
  defp submit_label(_), do: dgettext("materials", "Update")
end
