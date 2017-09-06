defmodule Ptr.Accounts.Password do
  import Ecto.Query

  alias Ptr.Accounts.User
  alias Ptr.Notifications
  alias Ptr.Repo

  def get_user_by_token(token) do
    user_by_token = from u in User,
                      where: u.password_reset_token   == ^token,
                      where: u.password_reset_sent_at >= ago(6, "hour")

    Repo.one(user_by_token)
  end

  def reset(%User{} = user) do
    {:ok, %{model: user_with_token}} =
      user
      |> User.password_reset_token_changeset()
      |> PaperTrail.update()

    Notifications.send_password_reset(user_with_token)

    {:ok, user_with_token}
  end
end
