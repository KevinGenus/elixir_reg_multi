defmodule Practice.UserProfilesTest do
  use Practice.DataCase

  alias Practice.UserProfiles

  describe "user_profiles" do
    alias Practice.UserProfiles.UserProfile

    import Practice.UserProfilesFixtures

    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_user_profiles/0 returns all user_profiles" do
      user_profile = user_profile_fixture()
      assert UserProfiles.list_user_profiles() == [user_profile]
    end

    test "get_user_profile!/1 returns the user_profile with given id" do
      user_profile = user_profile_fixture()
      assert UserProfiles.get_user_profile!(user_profile.id) == user_profile
    end

    test "create_user_profile/1 with valid data creates a user_profile" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name"}

      assert {:ok, %UserProfile{} = user_profile} = UserProfiles.create_user_profile(valid_attrs)
      assert user_profile.first_name == "some first_name"
      assert user_profile.last_name == "some last_name"
    end

    test "create_user_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserProfiles.create_user_profile(@invalid_attrs)
    end

    test "update_user_profile/2 with valid data updates the user_profile" do
      user_profile = user_profile_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name"}

      assert {:ok, %UserProfile{} = user_profile} = UserProfiles.update_user_profile(user_profile, update_attrs)
      assert user_profile.first_name == "some updated first_name"
      assert user_profile.last_name == "some updated last_name"
    end

    test "update_user_profile/2 with invalid data returns error changeset" do
      user_profile = user_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = UserProfiles.update_user_profile(user_profile, @invalid_attrs)
      assert user_profile == UserProfiles.get_user_profile!(user_profile.id)
    end

    test "delete_user_profile/1 deletes the user_profile" do
      user_profile = user_profile_fixture()
      assert {:ok, %UserProfile{}} = UserProfiles.delete_user_profile(user_profile)
      assert_raise Ecto.NoResultsError, fn -> UserProfiles.get_user_profile!(user_profile.id) end
    end

    test "change_user_profile/1 returns a user_profile changeset" do
      user_profile = user_profile_fixture()
      assert %Ecto.Changeset{} = UserProfiles.change_user_profile(user_profile)
    end
  end
end
