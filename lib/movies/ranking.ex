defmodule Movies.Ranking do
  import Ecto.Query

  alias Movies.Rating
  alias Movies.Movie
  alias Movies.Repo

  def top_100 do
    Rating
      |> join(:inner, [r], m in Movie, on: r.movie_id == m.id)
      |> select([r, m], %{movie_title: m.title, rating: fragment("round(?, 2)", avg(r.rating)), count: count(r.id)})
      |> group_by([r, m], m.title)
      |> having([r, m], count(r.id) > 20)
      |> order_by([r, m], desc: [fragment("round(?, 2)", avg(r.rating)), count(r.id)])
      |> limit(100)
      |> Repo.all
  end
end
