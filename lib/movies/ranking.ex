defmodule Movies.Ranking do
  import Ecto.Query

  alias Movies.Movie
  alias Movies.Rating
  alias Movies.Repo
  alias Movies.User

  def top_100(nil) do
    base_query
      |> Repo.all
  end

  def top_100(age_id) do
    base_query
      |> where([r, m], r.user_id in ^user_ids_for_age(age_id))
      |> Repo.all
  end

  defp base_query do
    Rating
      |> join(:inner, [r], m in Movie, on: r.movie_id == m.id)
      |> select([r, m], %{movie_title: m.title, rating: fragment("round(?, 2)", avg(r.rating)), count: count(r.id)})
      |> group_by([r, m], m.title)
      |> having([r, m], count(r.id) > 20)
      |> order_by([r, m], desc: [fragment("round(?, 2)", avg(r.rating)), count(r.id)])
      |> limit(100)
  end

  defp user_ids_for_age(age_id) do
    User
      |> select([:id])
      |> where(age_id: ^age_id)
      |> Repo.all
      |> Enum.map(& &1.id)
  end
end
