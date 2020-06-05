defmodule MoviesWeb.PageController do
  use MoviesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
