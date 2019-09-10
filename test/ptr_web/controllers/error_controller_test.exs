defmodule PtrWeb.ErrorControllerTest do
  use PtrWeb.ConnCase, async: true

  describe "route errors" do
    test "get a 404" do
      {_status_code, _content_type, body} =
        assert_error_sent 404, fn ->
          get(build_conn(), "/not_found")
        end

      assert body =~ "Page not found"
    end
  end
end
