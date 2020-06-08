defmodule Movies.RankingTest do
  use Movies.DataCase

  import Movies.Factory

  describe "without a movie which has more than 20 ratings" do
    test "#top_100 returns an empty array" do
      for i <- 0..20, i > 0, do: insert!(:rating, %{user_id: i + 1})

      assert Movies.Ranking.top_100 == []
    end
  end

  describe "with a movie which has more than 20 ratings" do
    setup [:create_movies]

    test "#top_100 returns the movie in the ranking", context do
      for i <- 0..21, i > 0, do: insert!(:rating, %{user_id: i + 1, movie_id: context[:movie1].id})

      assert Movies.Ranking.top_100 == [%{count: 21, movie_title: context[:movie1].title, rating: Decimal.new("5.00")}]
    end

    test "#top_100 returns first the movies with a higher average", context do
      for i <- 0..21, i > 0, do: insert!(:rating, %{user_id: i + 1, movie_id: context[:movie1].id})
      for i <- 0..21, i > 0, do: insert!(:rating, %{movie_id: context[:movie2].id, rating: 4, user_id: i + 1})

      assert Movies.Ranking.top_100 == [
        %{count: 21, movie_title: context[:movie1].title, rating: Decimal.new("5.00")},
        %{count: 21, movie_title: context[:movie2].title, rating: Decimal.new("4.00")}
      ]
    end

    test "#top_100 returns first the movies with more votes if they have the same average", context do
      for i <- 0..22, i > 0, do: insert!(:rating, %{user_id: i + 1, movie_id: context[:movie1].id})
      for i <- 0..21, i > 0, do: insert!(:rating, %{movie_id: context[:movie2].id, rating: 5, user_id: i + 1})

      assert Movies.Ranking.top_100 == [
        %{count: 22, movie_title: context[:movie1].title, rating: Decimal.new("5.00")},
        %{count: 21, movie_title: context[:movie2].title, rating: Decimal.new("5.00")}
      ]
    end

    defp create_movies(_context) do
      movie1 = insert!(:movie)
      movie2 = insert!(:movie, %{title: "Rocky"})

      [movie1: movie1, movie2: movie2]
    end
  end
end
