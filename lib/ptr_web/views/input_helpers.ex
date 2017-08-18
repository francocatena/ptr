defmodule PtrWeb.InputHelpers do
  use Phoenix.HTML

  import PtrWeb.ErrorHelpers, only: [error_tag: 2]

  def input(form, field, label \\ nil, opts \\ []) do
    type  = opts[:using] || input_type(form, field)
    error = error_tag(form, field)

    content_tag(:div, class: "field") do
      label = label_for(form, field, label)
      input = input(type, form, field, error, opts)

      [label, input, error]
    end
  end

  defp label_for(form, field, label) do
    label(form, field, label || humanize(field), class: "label")
  end

  defp input_opts(form, field, error, opts) do
    default_opts = [class: input_class(error)]
    validations  = input_validations(form, field)

    default_opts
    |> Keyword.merge(validations)
    |> Keyword.merge(opts)
  end

  defp input_class([]), do: "input"
  defp input_class(_),  do: "input is-danger"

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, error, opts) do
  #   raise "not yet implemented"
  # end
  defp input(type, form, field, error, opts) do
    input_opts = input_opts(form, field, error, opts)

    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
