defmodule Movies.RankingTest do
  use Movies.DataCase

  import Movies.Factory

  describe "without a movie which has more than 20 ratings" do
    test "#top_100 returns an empty array" do
      for i <- 0..20, i > 0, do: insert!(:rating, %{user_id: i + 1})

      assert Movies.Ranking.top_100(%{age_id: nil, genre_title: nil}) == []
    end
  end

  describe "with a movie which has more than 20 ratings" do
    setup [:create_movies, :create_ratings]

    test "#top_100 returns first the movies with a higher average", _ do
      assert Movies.Ranking.top_100(%{age_id: nil, genre_title: nil}) == [
        %{count: 21, movie_title: "The Matrix", rating: Decimal.new("5.00")},
        %{count: 21, movie_title: "Harry Potter", rating: Decimal.new("5.00")},
        %{count: 21, movie_title: "Rocky", rating: Decimal.new("4.00")}
      ]
    end

    test "#top_100 returns first the movies with more votes if they have the same average", context do
      insert!(:rating, %{user_id: 999_999, movie_id: context.movie_3.id})

      assert Movies.Ranking.top_100(%{age_id: nil, genre_title: nil}) == [
        %{count: 22, movie_title: "Harry Potter", rating: Decimal.new("5.00")},
        %{count: 21, movie_title: "The Matrix", rating: Decimal.new("5.00")},
        %{count: 21, movie_title: "Rocky", rating: Decimal.new("4.00")}
      ]
    end

    test "#top_100 filters by age group if provided", _ do
      assert Movies.Ranking.top_100(%{age_id: 1, genre_title: nil}) == [%{count: 21, movie_title: "The Matrix", rating: Decimal.new("5.00")}]
    end

    test "#top_100 filters by genre_title if provided", _ do
      assert Movies.Ranking.top_100(%{age_id: nil, genre_title: "Fiction"}) == [%{count: 21, movie_title: "Harry Potter", rating: Decimal.new("5.00")}]
    end

    test "#top_100 filters by age_id & genre_title if provided", _ do
      assert Movies.Ranking.top_100(%{age_id: 1, genre_title: "Fiction"}) == []
    end

    defp create_ratings(context) do
      for i <- 0..21, i > 0 do
        user_1 = insert!(:user)
        insert!(:rating, %{user_id: user_1.id, movie_id: context.movie_1.id})

        user_2 = insert!(:user, %{age_id: 2})
        insert!(:rating, %{user_id: user_2.id, movie_id: context.movie_2.id, rating: 4})

        user_3 = insert!(:user, %{age_id: 3})
        insert!(:rating, %{user_id: user_3.id, movie_id: context.movie_3.id})
      end

      :ok
    end

    defp create_movies(_context) do
      movie_1 = insert!(:movie)
      movie_2 = insert!(:movie, %{title: "Rocky", genres: "Action"})
      movie_3 = insert!(:movie, %{title: "Harry Potter", genres: "Fiction"})

      [movie_1: movie_1, movie_2: movie_2, movie_3: movie_3]
    end
  end
end
