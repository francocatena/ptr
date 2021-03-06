defmodule PtrWeb.VesselView do
  use PtrWeb, :view
  use Scrivener.HTML

  alias PtrWeb.VesselView

  def link_to_show(conn, cellar, vessel) do
    icon_link(
      "eye",
      title: dgettext("vessels", "Show"),
      to: Routes.cellar_vessel_path(conn, :show, cellar, vessel),
      class: "button is-small is-outlined is-hidden-mobile",
      data: [target: "link.link"]
    )
  end

  def link_to_edit(conn, cellar, vessel) do
    icon_link(
      "pen",
      title: dgettext("vessels", "Edit"),
      to: Routes.cellar_vessel_path(conn, :edit, cellar, vessel),
      class: "button is-small is-outlined is-hidden-mobile"
    )
  end

  def link_to_delete(conn, cellar, vessel) do
    icon_link(
      "trash",
      title: dgettext("vessels", "Delete"),
      to: Routes.cellar_vessel_path(conn, :delete, cellar, vessel),
      method: :delete,
      data: [confirm: dgettext("vessels", "Are you sure?")],
      class: "button is-small is-danger is-outlined"
    )
  end

  def lock_version_input(_, nil), do: nil

  def lock_version_input(form, vessel) do
    hidden_input(form, :lock_version, value: vessel.lock_version)
  end

  def submit_button(vessel) do
    vessel
    |> submit_label()
    |> submit(class: "button is-medium is-white is-paddingless card-footer-item")
  end

  def materials(account) do
    account
    |> Ptr.Options.list_materials()
    |> Enum.map(&[key: &1.name, value: &1.id])
  end

  def cooling do
    [
      [key: dgettext("vessels", "None"), value: "None"],
      [key: dgettext("vessels", "Jacket"), value: "Jacket"],
      [key: dgettext("vessels", "Coil"), value: "Coil"]
    ]
  end

  def render_js_vessels(conn, cellar, vessels) do
    data =
      vessels
      |> render_many(VesselView, "vessel.html", conn: conn, cellar: cellar)
      |> Enum.map(&safe_to_string/1)
      |> Enum.join()

    javascript_escape({:safe, data})
  end

  def render_js_pagination(conn, page, cellar) do
    opts = [path: &Routes.cellar_vessel_path/4]

    conn
    |> pagination_links(page, [cellar], opts)
    |> javascript_escape()
  end

  def progress(vessel, opts \\ [class: "progress"]) do
    progress = percent_usage(vessel)
    class = progress_class(progress)

    content_tag(
      :progress,
      "#{progress}%",
      class: "#{opts[:class]} #{class}",
      max: 100,
      title: "#{progress}%",
      value: progress
    )
  end

  defp submit_label(nil), do: dgettext("vessels", "Create")
  defp submit_label(_), do: dgettext("vessels", "Update")

  defp percent_usage(vessel) do
    vessel.usage
    |> Decimal.div(vessel.capacity)
    |> Decimal.mult(100)
    |> Decimal.round()
    |> Decimal.to_string()
  end

  defp progress_class(progress) do
    cond do
      Decimal.cmp(progress, 99) == :gt -> "is-success"
      Decimal.cmp(progress, 80) == :gt -> "is-warning"
      true -> "is-danger"
    end
  end
end
