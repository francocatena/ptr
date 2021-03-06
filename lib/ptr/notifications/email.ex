defmodule Ptr.Notifications.Email do
  use Bamboo.Phoenix, view: PtrWeb.EmailView

  import Bamboo.Email
  import PtrWeb.Gettext

  alias Ptr.Accounts.User

  def password_reset(%User{} = user) do
    subject = dgettext("emails", "Password reset")

    base_email()
    |> to(user.email)
    |> subject(subject)
    |> render(:password_reset, user: user)
  end

  defp base_email() do
    new_email()
    |> from({gettext("Vintock"), "support@vintock.com"})
    |> put_layout({PtrWeb.LayoutView, :email})
  end
end
