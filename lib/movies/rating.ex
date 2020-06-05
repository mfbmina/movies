defmodule Movies.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :rating, :integer

    belongs_to :movie, Movies.Movie
    belongs_to :user, Movies.User

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:rating, :movie_id, :user_id])
    |> validate_required([:rating, :movie_id, :user_id])
  end
end
