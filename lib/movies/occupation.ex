defmodule Movies.Occupation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "occupations" do
    field :title, :string
  end

  @doc false
  def changeset(occupation, attrs) do
    occupation
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
