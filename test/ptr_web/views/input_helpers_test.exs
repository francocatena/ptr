defmodule PtrWeb.InputHelpersTest do
  use PtrWeb.ConnCase, async: true

  describe "input" do
    import PtrWeb.InputHelpers
    import Phoenix.HTML.Form, only: [form_for: 4]
    import Phoenix.HTML, only: [safe_to_string: 1]

    test "with default options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name)
          |> safe_to_string()

        assert input =~ "Name"
        assert input =~ "class=\"field\""
        assert input =~ "class=\"control\""
        assert input =~ "class=\"input\""
        assert input =~ "class=\"label\""
        refute input =~ "has-icons"
        ""
      end)
    end

    test "with custom input options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, input_html: [class: "test-input-class"])
          |> safe_to_string()

        assert input =~ "test-input-class"
        refute input =~ "input_html"
        ""
      end)
    end

    test "with custom label options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, "Test label", label_html: [class: "test-label-class"])
          |> safe_to_string()

        assert input =~ "Test label"
        assert input =~ "test-label-class"
        refute input =~ "label_html"
        ""
      end)
    end

    test "with using option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, using: :password_input)
          |> safe_to_string()

        assert input =~ "type=\"password\""
        refute input =~ "using"
        ""
      end)
    end

    test "with icons option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, icons: [left: "envelope", right: "warning"])
          |> safe_to_string()

        assert input =~ "has-icons-left has-icons-right"
        assert input =~ "is-left"
        assert input =~ "is-right"
        assert input =~ "fa-envelope"
        assert input =~ "fa-warning"
        refute input =~ "icons="
        ""
      end)
    end

    test "with icons left option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, nil, icons: [left: "envelope"])
          |> safe_to_string()

        assert input =~ "has-icons-left"
        refute input =~ "has-icons-right"
        assert input =~ "is-left"
        refute input =~ "is-right"
        assert input =~ "fa-envelope"
        refute input =~ "icons="
        ""
      end)
    end
  end
end
