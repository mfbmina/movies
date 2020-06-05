defmodule Movies.Age do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ages" do
    field :title, :string
  end

  @doc false
  def changeset(age, attrs) do
    age
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
