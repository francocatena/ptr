defmodule Ptr.NotificationsTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Ptr.Accounts.User
  alias Ptr.Notifications
  alias Ptr.Notifications.Email

  test "password reset email" do
    user = %User{email: "some@email.com"}

    Notifications.send_password_reset(user)

    assert_delivered_email Email.password_reset(user)
  end
end
