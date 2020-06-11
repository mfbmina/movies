defmodule MoviesWeb.RankingController do
  use MoviesWeb, :controller

  def top(conn, params) do
    age_id = params["age_id"]
    genre_title = params["genre_title"]
    ranking = Movies.Ranking.top_100(%{age_id: age_id, genre_title: genre_title})

    render(conn, "top.html", ranking: ranking, ages: ages, genres: genres)
  end

  defp ages do
    Movies.Age
      |> Movies.Repo.all
      |> Enum.map(&{&1.title, &1.id})
  end

  defp genres do
    [
      {"Action", "Action"}, {"Adventure", "Adventure"}, {"Animation", "Animation"}, {"Children's", "Children's"},
      {"Comedy", "Comedy"}, {"Crime", "Crime"}, {"Documentary", "Documentary"}, {"Drama", "Drama"},
      {"Fantasy", "Fantasy"}, {"Film-Noir", "Film-Noir"}, {"Horror", "Horror"}, {"Musical", "Musical"},
      {"Mystery", "Mystery"}, {"Romance", "Romance"}, {"Sci-Fi", "Sci-Fi"}, {"Thriller", "Thriller"},
      {"War", "War"}, {"Western", "Western"}
    ]
  end
end
