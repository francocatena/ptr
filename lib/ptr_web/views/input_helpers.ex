defmodule PtrWeb.InputHelpers do
  use Phoenix.HTML

  import PtrWeb.ErrorHelpers, only: [error_tag: 2]

  def input(form, field, label \\ nil, opts \\ []) do
    input_html = opts[:input_html] || []
    label_html = opts[:label_html] || [class: "label"]
    type       = opts[:using]      || input_type(form, field)
    icon_opts  = opts[:icons]      || []
    errors     = error_tag(form, field)

    content_tag(:div, class: "field") do
      label = label_for(form, field, label, label_html)
      input = input(type, form, field, errors, icon_opts, input_html)

      [label, input, errors]
    end
  end

  defp label_for(form, field, nil, label_html) do
    label(form, field, humanize(field), label_html)
  end

  defp label_for(form, field, label, label_html) do
    label(form, field, label, label_html)
  end

  defp input(type, form, field, errors, icon_opts, input_html) do
    input_opts   = input_opts(form, field, errors, input_html)
    input        = apply(Phoenix.HTML.Form, type, [form, field, input_opts])
    content_opts = [class: wrapper_classes(icon_opts)]

    content_tag(:div, content_opts) do
      [input | input_icons(icon_opts)]
    end
  end

  defp input_opts(form, field, errors, opts) do
    {class, opts} = Keyword.pop(opts, :class)
    default_opts  = [class: input_class(class || "input", errors)]
    validations   = input_validations(form, field)

    default_opts
    |> Keyword.merge(validations)
    |> Keyword.merge(opts)
  end

  defp input_class(default, []), do: default
  defp input_class(default, _),  do: "#{default} is-danger"

  defp input_icons(icon_opts) do
    for {position, icon} <- icon_opts do
      content_tag(:span, class: "icon is-#{position}") do
        content_tag(:i, "", class: "fa fa-#{icon}")
      end
    end
  end

  defp wrapper_classes(icon_opts) do
    icon_classes = for {position, _} <- icon_opts, do: "has-icons-#{position}"

    ["control" | icon_classes] |> Enum.join(" ")
  end
end
