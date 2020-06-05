defmodule Movies.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :gender, :string
    field :zipcode, :string

    belongs_to :age, Movies.Age
    belongs_to :occupation, Movies.Occupation
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:gender, :zipcode, :age_id, :occupation_id])
    |> validate_required([:gender, :zipcode, :age_id, :occupation_id])
  end
end
