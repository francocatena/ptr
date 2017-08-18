defmodule PtrWeb.UserView do
  use PtrWeb, :view
  use Scrivener.HTML

  def fullname(user) do
    Enum.join([user.name, user.lastname], " ")
  end

  def link_to_show(conn, user) do
    link gettext("Show"), to: user_path(conn, :show, user), class: "button is-small"
  end

  def link_to_edit(conn, user) do
    link gettext("Edit"), to: user_path(conn, :edit, user), class: "button is-small"
  end

  def link_to_delete(conn, user) do
    link gettext("Delete"), to:     user_path(conn, :delete, user),
                            method: :delete,
                            data:   [confirm: gettext("Are you sure?")],
                            class:  "button is-small is-danger"
  end
end
