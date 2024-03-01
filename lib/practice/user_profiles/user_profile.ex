defmodule Practice.UserProfiles.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_profiles" do
    field :first_name, :string
    field :last_name, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:first_name, :last_name, :user_id])
    |> validate_required([:first_name, :last_name, :user_id])
  end
end
