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
        ""
      end)
    end

    test "with custom options", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, "Test label", class: "test_class")
          |> safe_to_string()

        assert input =~ "Test label"
        assert input =~ "test_class"
        ""
      end)
    end

    test "with using option", %{conn: conn} do
      form_for(conn, "/", [as: :test], fn form ->
        input =
          input(form, :name, "Test label", using: :password_input)
          |> safe_to_string()

        assert input =~ "type=\"password\""
        ""
      end)
    end
  end
end
