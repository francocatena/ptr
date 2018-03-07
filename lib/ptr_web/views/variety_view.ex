defmodule PtrWeb.VarietyView do
  use PtrWeb, :view
  use Scrivener.HTML

  alias Ptr.Options.Variety

  def link_to_show(conn, variety) do
    icon_link(
      "eye",
      title: dgettext("varieties", "Show"),
      to: variety_path(conn, :show, variety),
      class: "button is-small is-outlined is-hidden-mobile",
      data: [main_link: true]
    )
  end

  def link_to_edit(conn, variety) do
    icon_link(
      "pencil-alt",
      title: dgettext("varieties", "Edit"),
      to: variety_path(conn, :edit, variety),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, %Variety{lots_count: 0} = variety) do
    icon_link(
      "trash",
      title: dgettext("varieties", "Delete"),
      to: variety_path(conn, :delete, variety),
      method: :delete,
      data: [confirm: dgettext("varieties", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def link_to_delete(_conn, _variety), do: nil

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, variety) do
    hidden_input(form, :lock_version, value: variety.lock_version)
  end

  def submit_button(variety) do
    submit_label(variety)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  defp submit_label(nil), do: dgettext("varieties", "Create")
  defp submit_label(_), do: dgettext("varieties", "Update")
end
