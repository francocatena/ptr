defmodule PtrWeb.CacheControlPlugTest do
  use PtrWeb.ConnCase, async: true

  alias PtrWeb.CacheControlPlug

  describe "cache control headers" do
    test "put cache control headers correctly when current user", %{conn: conn} do
      conn = CacheControlPlug.put_cache_control_headers(conn, [])

      assert get_resp_header(conn, "cache-control") == [
               "no-cache, no-store, max-age=0, must-revalidate"
             ]

      assert get_resp_header(conn, "pragma") == ["no-cache"]
      assert get_resp_header(conn, "expires") == ["Fri, 01 Jan 1990 00:00:00 GMT"]
    end

    test "put cache control headers through browser pipe when current user", %{conn: conn} do
      conn =
        conn
        |> bypass_through(PtrWeb.Router, :browser)
        |> get("/")

      assert get_resp_header(conn, "cache-control") == [
               "no-cache, no-store, max-age=0, must-revalidate"
             ]

      assert get_resp_header(conn, "pragma") == ["no-cache"]
      assert get_resp_header(conn, "expires") == ["Fri, 01 Jan 1990 00:00:00 GMT"]
    end
  end
end
