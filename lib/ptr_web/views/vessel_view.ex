defmodule PtrWeb.VesselView do
  use PtrWeb, :view
  use Scrivener.HTML

  def link_to_show(conn, cellar, vessel) do
    icon_link "eye",
      title: dgettext("vessels", "Show"),
      to:    cellar_vessel_path(conn, :show, cellar, vessel),
      class: "button is-small is-outlined is-hidden-mobile",
      data:  [main_link: true]
  end

  def link_to_edit(conn, cellar, vessel) do
    icon_link "pencil",
      title: dgettext("vessels", "Edit"),
      to:    cellar_vessel_path(conn, :edit, cellar, vessel),
      class: "button is-small is-outlined is-hidden-mobile"
  end

  def link_to_delete(conn, cellar, vessel) do
    icon_link "trash",
      title:  dgettext("vessels", "Delete"),
      to:     cellar_vessel_path(conn, :delete, cellar, vessel),
      method: :delete,
      data:   [confirm: dgettext("vessels", "Are you sure?")],
      class:  "button is-small is-danger is-outlined"
  end

  def lock_version_input(_, nil), do: nil
  def lock_version_input(form, vessel) do
    hidden_input form, :lock_version, [value: vessel.lock_version]
  end

  def submit_button(vessel) do
    submit_label(vessel)
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  def materials do
    [
      [key: dgettext("vessels", "Steel"),    value: "Steel"],
      [key: dgettext("vessels", "Concrete"), value: "Concrete"],
      [key: dgettext("vessels", "Fiber"),    value: "Fiber"],
      [key: dgettext("vessels", "Plastic"),  value: "Plastic"],
      [key: dgettext("vessels", "Wood"),     value: "Wood"]
    ]
  end

  def cooling do
    [
      [key: dgettext("vessels", "None"),   value: "None"],
      [key: dgettext("vessels", "Jacket"), value: "Jacket"],
      [key: dgettext("vessels", "Coil"),   value: "Coil"]
    ]
  end

  defp submit_label(nil), do: dgettext("vessels", "Create")
  defp submit_label(_),   do: dgettext("vessels", "Update")
end
