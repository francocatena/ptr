defmodule Ptr.Notifications do
  alias Ptr.Accounts.User
  alias Ptr.Notifications.{Mailer, Email}

  def send_password_reset(%User{} = user) do
    Email.password_reset(user)
    |> Mailer.deliver_later()
  end
end
