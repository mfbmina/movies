defmodule MoviesWeb.RankingController do
  use MoviesWeb, :controller

  def top(conn, _params) do
    render(conn, "top.html", ranking: Movies.Ranking.top_100)
  end
end
