defmodule Ptr.Accounts.AuthTest do
  use Ptr.DataCase

  describe "auth" do
    alias Ptr.Accounts.Auth

    @valid_attrs %{email: "some@email.com", lastname: "some lastname", name: "some name", password: "123456"}

    test "authenticate_by_email_and_password/2 returns :ok with valid credentials" do
      user     = fixture(:user, @valid_attrs)
      email    = @valid_attrs.email
      password = @valid_attrs.password

      {:ok, auth_user} = Auth.authenticate_by_email_and_password(email, password)

      assert auth_user == user
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid credentials" do
      email    = @valid_attrs.email
      password = "wrong"

      fixture(:user, @valid_attrs) # Create user just to be sure

      assert {:error, :unauthorized} ==
        Auth.authenticate_by_email_and_password(email, password)
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid email" do
      email    = "invalid@email.com"
      password = @valid_attrs.password

      assert {:error, :unauthorized} ==
        Auth.authenticate_by_email_and_password(email, password)
    end
  end
end
