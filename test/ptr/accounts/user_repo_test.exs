defmodule Ptr.Accounts.UserRepoTest do
  use Ptr.DataCase

  describe "user" do
    alias Ptr.Accounts.User

    @valid_attrs %{email: "some@email.com", lastname: "some lastname", name: "some name", password: "123456"}

    test "converts unique constraint on email to error" do
      user      = fixture(:user, @valid_attrs)
      attrs     = Map.put(@valid_attrs, :email, user.email)
      changeset = User.create_changeset(%User{account_id: user.account_id}, attrs)

      assert {:error, changeset} = Repo.insert(changeset)
      assert "has already been taken" in errors_on(changeset).email
    end
  end
end
