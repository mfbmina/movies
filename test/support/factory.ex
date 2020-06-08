defmodule Movies.Factory do
  alias Movies.Repo

  # Factories

  def build(:rating) do
    %Movies.Rating{rating: 5, movie_id: 1, user_id: 1}
  end

  def build(:movie) do
    %Movies.Movie{title: "The Matrix", genres: "Action"}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end
end
