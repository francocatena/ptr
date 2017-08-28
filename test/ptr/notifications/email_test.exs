defmodule Ptr.Notifications.EmailTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Ptr.Accounts.User
  alias Ptr.Notifications.Email

  test "password reset email" do
    user = %User{email: "some@email.com"}

    email = Email.password_reset(user)

    assert email.to == user.email
    assert email.html_body =~ user.email
    assert email.text_body =~ user.email
  end
end
