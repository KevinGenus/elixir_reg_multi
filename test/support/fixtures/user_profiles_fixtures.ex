defmodule Practice.UserProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Practice.UserProfiles` context.
  """

  @doc """
  Generate a user_profile.
  """
  def user_profile_fixture(attrs \\ %{}) do
    {:ok, user_profile} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Practice.UserProfiles.create_user_profile()

    user_profile
  end
end
