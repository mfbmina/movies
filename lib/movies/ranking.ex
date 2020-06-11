defmodule Movies.Ranking do
  import Ecto.Query

  alias Movies.Movie
  alias Movies.Rating
  alias Movies.Repo
  alias Movies.User


  def top_100(%{age_id: age_id, genre_title: genre_title}) do
    base_query()
      |> apply_age_id_filter(age_id)
      |> apply_genre_title_filter(genre_title)
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

  defp apply_age_id_filter(query, age_id) do
    case age_id do
      nil -> query
      "" -> query
      _ -> query |> where([r, m], r.user_id in ^user_ids_for_age(age_id))
    end
  end

  defp apply_genre_title_filter(query, genre_title) do
    title = "%#{genre_title}%"

    case title do
      "%%" -> query
      _ -> query |> where([r, m], like(m.genres, ^title))
    end
  end

  defp user_ids_for_age(age_id) do
    User
      |> select([:id])
      |> where(age_id: ^age_id)
      |> Repo.all
      |> Enum.map(& &1.id)
  end
end
