defmodule MoviesWeb.MovieControllerTest do
  use MoviesWeb.ConnCase

  test "GET /top", %{conn: conn} do
    conn = get(conn, "/top")
    assert html_response(conn, 200) =~ "Top 100 movies"
  end
end
