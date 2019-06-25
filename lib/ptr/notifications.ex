defmodule Ptr.Notifications do
  alias Ptr.Accounts.User
  alias Ptr.Notifications.{Mailer, Email}

  def send_password_reset(%User{} = user) do
    user
    |> Email.password_reset()
    |> Mailer.deliver_later()
  end
end
