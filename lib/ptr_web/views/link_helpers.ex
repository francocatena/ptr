defmodule PtrWeb.LinkHelpers do
  import Phoenix.HTML.Link, only: [link: 2]
  import Phoenix.HTML.Tag,  only: [content_tag: 3]

  def icon_link(icon, opts) do
    link(opts) do
      content_tag(:i, "", class: "fa fa-#{icon}")
    end
  end
end
