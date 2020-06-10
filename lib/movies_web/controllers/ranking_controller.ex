defmodule MoviesWeb.RankingController do
  use MoviesWeb, :controller

  def top(conn, _params) do
    ages = Movies.Age
      |> Movies.Repo.all
      |> Enum.map(&{&1.title, &1.id})

    age_id = conn.query_params["age_id"]

    render(conn, "top.html", ranking: Movies.Ranking.top_100(age_id), ages: ages)

  end
end
